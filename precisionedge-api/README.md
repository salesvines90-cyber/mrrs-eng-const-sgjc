# Developer Setup Instructions: PrecisionEdge API

This repository houses the backend REST API and WebSocket services for the PrecisionEdge sub-contractor management system. It acts as the orchestration layer between the frontend PWA, Supabase (PostgreSQL), and third-party integrations.

## 1. Technical Stack Requirements
*   **Runtime Engine:** Node.js (LTS Version)
*   **Framework:** Fastify or Express (Lightweight, low-overhead REST architecture)
*   **Real-Time Layer:** `ws` or `socket.io` (For live factory floor monitoring and site updates)
*   **Database Client:** Supabase JS Client / Prisma (Connecting to our free-tier PostgreSQL instance)

## 2. Global Coding Constraints (Non-Negotiable)
*   **Stateless Execution:** The API layer must remain completely stateless to allow hosting on free serverless container tiers without session loss.
*   **Strict Metric Validation:** All incoming payloads for dimensions, weights, or areas must be validated at the router level. Reject any payload containing non-metric formats.
*   **Data Minimization:** To optimize database performance on the free tier, API responses must selectively return only the columns required by the UI view. Avoid `SELECT *` queries.

## 3. Local Development Setup
To spin up the backend API locally, clone this folder and run:

```bash
# Install required dependencies
npm install

# Start the local API server in development mode
npm run dev
