# Developer Setup Instructions: PrecisionEdge Frontend

This repository houses the frontend Progressive Web Application (PWA) for the PrecisionEdge sub-contractor management system. It communicates with the `precisionedge-api` and uses Supabase for database operations.

## 1. Technical Stack Requirements
*   **Framework:** React (Vite-powered for lean, fast builds)
*   **Deployment Target:** Vercel (Hobby/Free Tier)
*   **Package Manager:** `npm`
*   **Core UI Libraries:** TailwindCSS (Styling), `lucide-react` (Icons)
*   **PWA Support:** `vite-plugin-pwa`
*   **Key Features:** Camera-based barcode scanning (`html5-qrcode`), lightweight open-source 3D/BIM viewing (`three.js` or `ifc.js`).

## 2. Global Coding Constraints (Non-Negotiable)
*   **Zero Paid Dependencies:** Do not install any library, map service, or 3D engine that requires a credit card, paid license, or api key subscription. Stick strictly to open-source tools.
*   **Client-Side Processing:** All QR code scanning and 3D model parsing must run entirely on the client’s browser device to maintain a $0/month server overhead.
*   **Metric System Only:** All UI fields, inputs, data displays, and validation rules must strictly enforce metric units (m, mm, kg, m², Set, LS). Imperial units are explicitly banned.

## 3. Local Development Setup
To spin up the frontend application locally, clone this folder and run:

```bash
# Install free, open-source dependencies
npm install

# Run the local development server
npm run dev
