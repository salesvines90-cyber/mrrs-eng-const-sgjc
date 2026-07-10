-- PrecisionEdge: Module 1 - Quotation & Estimating Schema
-- Database Target: PostgreSQL / Supabase

-- Enums for Strict Unit of Measure (Metric Only)
CREATE TYPE uom_type AS ENUM ('m', 'mm', 'kg', 'm2', 'Set', 'LS');

-- Enums for Quotation Status
CREATE TYPE quote_status AS ENUM ('Draft', 'Pending_Approval', 'Submitted', 'Awarded', 'Lost', 'Revised');

-- 1. Projects Table (Top-level container)
CREATE TABLE projects (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    main_contractor_name VARCHAR(255) NOT NULL,
    location_details TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- 2. Quotations Table
CREATE TABLE quotations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    project_id UUID REFERENCES projects(id) ON DELETE CASCADE NOT NULL,
    version_number INT DEFAULT 1 NOT NULL,
    status quote_status DEFAULT 'Draft' NOT NULL,
    total_material_cost_sgd NUMERIC(15, 2) DEFAULT 0.00 NOT NULL,
    total_labour_cost_sgd NUMERIC(15, 2) DEFAULT 0.00 NOT NULL,
    total_margin_percentage NUMERIC(5, 2) DEFAULT 0.00 NOT NULL,
    final_quote_amount_sgd NUMERIC(15, 2) DEFAULT 0.00 NOT NULL,
    confidence_score INT CHECK (confidence_score BETWEEN 0 AND 100),
    estimated_duration_days INT,
    created_by UUID NOT NULL, -- Ties to Supabase auth.users
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    UNIQUE (project_id, version_number)
);

-- 3. Material Price Index Library (For live linking)
CREATE TABLE material_price_indices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    material_name VARCHAR(100) NOT NULL, -- e.g., 'Stainless Steel 316L', 'Aluminium EN 755'
    base_price_per_kg_sgd NUMERIC(10, 2) NOT NULL,
    last_updated_api TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- 4. Quotation Line Items (The core scope breakdown)
CREATE TABLE quotation_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    quotation_id UUID REFERENCES quotations(id) ON DELETE CASCADE NOT NULL,
    item_code VARCHAR(50), -- e.g., 'BAL-01' for Balustrade type 1
    description TEXT NOT NULL,
    quantity NUMERIC(12, 3) NOT NULL,
    uom uom_type NOT NULL,
    unit_material_cost_sgd NUMERIC(12, 2) DEFAULT 0.00 NOT NULL,
    unit_labour_cost_sgd NUMERIC(12, 2) DEFAULT 0.00 NOT NULL,
    total_item_cost_sgd NUMERIC(15, 2) GENERATED ALWAYS AS ((unit_material_cost_sgd + unit_labour_cost_sgd) * quantity) STORED,
    linked_material_index_id UUID REFERENCES material_price_indices(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- 5. BIM Quantity Take-Off (QTO) Metadata
CREATE TABLE bim_takeoffs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    quotation_id UUID REFERENCES quotations(id) ON DELETE CASCADE NOT NULL,
    ifc_file_name VARCHAR(255) NOT NULL,
    uploaded_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    total_elements_parsed INT DEFAULT 0 NOT NULL,
    unassigned_elements_count INT DEFAULT 0 NOT NULL
);

-- 6. Capacity & Levy Log (For Confidence Score calculations)
CREATE TABLE quotation_capacity_checks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    quotation_id UUID REFERENCES quotations(id) ON DELETE CASCADE NOT NULL,
    required_man_hours NUMERIC(10, 2) NOT NULL,
    estimated_foreign_workers_needed INT NOT NULL,
    estimated_levy_cost_sgd NUMERIC(12, 2) NOT NULL,
    quota_warning_flag BOOLEAN DEFAULT FALSE NOT NULL,
    checked_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- Performance Indexes
CREATE INDEX idx_quotations_project ON quotations(project_id);
CREATE INDEX idx_quotation_items_quote ON quotation_items(quotation_id);
