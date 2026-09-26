# DevFlow ⚡

> **AI-Powered Code Review, Security Auditing & Release Gatekeeper**

DevFlow is an autonomous software quality and release-readiness engine designed to bridge the gap between rapid software development and rigorous production safety. By coupling **Groq AI (llama-3.3-70b-versatile)** with safe **Python AST static syntax verification**, DevFlow analyzes codebases, detects security flaws and regressions, synthesizes surgical code fixes, and enforces automated release gating without running untrusted code.

---

## 🌟 Key Features

- 🛡️ **Multi-Vector AI Auditing**: Detects security vulnerabilities (OWASP top 10, credential leaks, unverified JWTs), logic bugs, test coverage gaps, and maintainability antipatterns.
- ⚡ **Sub-Second Remediation**: Generates step-by-step root-cause analyses, implementation roadmaps, unified code diffs, and regression test suites.
- 🔒 **Zero Remote Code Execution (Zero RCE)**: Uses Python's native AST parser (`ast.parse`) for strict syntax verification without executing untrusted user code.
- 🗂️ **Zip Slip Protected**: Hardened upload pipeline preventing path traversal exploits from uploaded `.zip` archives.
- 📊 **Executive Release Gatekeeper**: Combines syntax verification with defect severity metrics to render a clear Go/No-Go release decision.
- ☁️ **Cloud Native & Offline Resilient**: Connects to **Supabase PostgreSQL** with Row-Level Security (RLS) while providing automated local in-memory fallback.

---

## 🛠️ Technology Stack & Separation of Roles

| Technology | Role | Details |
| :--- | :--- | :--- |
| **Flutter (Dart)** | **Frontend Dashboard** | Material 3 dark interface with live charts (`fl_chart`), audit flows, and remediation views. |
| **FastAPI (Python)** | **Backend API Server** | Asynchronous REST API, multipart ZIP handling, CORS orchestration, and Pydantic validation. |
| **Groq (`llama-3.3-70b`)** | **Runtime Application AI** | High-throughput LLM runtime powering live code analysis, fix generation, and test synthesis. |
| **Python AST (`ast.parse`)** | **Verification Engine** | Fast, deterministic, and safe syntax verification ensuring zero execution side-effects. |
| **Supabase (PostgreSQL)** | **Cloud Persistence** | Normalized relational schema with Row-Level Security (RLS) policies for user data isolation. |
| **IBM Bob 2.0** | **AI Engineering Copilot** | Autonomous development partner utilized across architecture, implementation, debugging, and documentation. |

> 💡 **Architectural Clarification**: Groq powers DevFlow's runtime AI features within the product, while IBM Bob 2.0 was used as an AI-assisted software engineering copilot throughout the development lifecycle.

---

## 📂 Project Structure

```text
devflow/
├── frontend/                    # Flutter cross-platform user interface
│   ├── lib/
│   │   ├── main.dart            # Flutter application entrypoint & screens
│   │   ├── models/              # Client-side data models
│   │   └── widgets/             # UI components
│   └── pubspec.yaml
│
├── backend/                     # FastAPI asynchronous backend service
│   ├── .env                     # Local environment credentials (ignored by git)
│   ├── .env.example             # Template environment variables
│   ├── requirements.txt         # Python dependencies
│   └── app/
│       ├── main.py              # Main API router and endpoints
│       ├── config/
│       │   └── settings.py      # Environment configuration reader
│       ├── ai/
│       │   ├── groq_client.py   # Async Groq client with JSON enforcement
│       │   └── prompts.py       # Production prompt engineering definitions
│       ├── services/
│       │   ├── project_service.py      # Project lifecycle management
│       │   ├── analysis_service.py     # AI analysis & remediation engine
│       │   ├── verification_service.py # Python AST syntax verifier
│       │   └── supabase_service.py     # Supabase database & fallback layer
│       ├── utils/
│       │   ├── file_parser.py   # Directory walker & unified code extractor
│       │   └── zip_handler.py   # Zip Slip safe extraction engine
│       └── schemas/
│           ├── project_schema.py       # Pydantic models for projects
│           └── analysis_schema.py      # Pydantic models for issues & fixes
│
├── supabase/                    # Database schemas and security rules
│   ├── 001_initial_schema.sql   # Relational tables, indexes, and constraints
│   └── 002_rls_policies.sql     # Row-Level Security policies
│
├── demo-project/                # Intentional flaw testbed for live judging
│   ├── README.md
│   ├── devflow app
│   ├── requirements.txt
│   ├── devflow_api.py           # Hardcoded secrets, unverified JWT, broad except
│   └── tests/
│       └── test_app.py          # Minimal test suite missing auth coverage
│
├── bob-evidence/                # Evidence of IBM Bob 2.0 utilization
│   ├── bob-workflow.md          # 5-phase engineering report
│   ├── screenshots/             # Generated visual proof artifacts
│   └── prompts/                 # Original engineering prompts
│
├── docs/                        # Complete technical documentation
│   ├── architecture.md          # Mermaid diagrams & system design
│   ├── api.md                   # REST API reference with curl examples
│   └── demo-script.md           # 10-step judge walkthrough script
│
├── .gitignore
└── README.md
```

---

# 🚀 Quickstart Guide

## 🔗 Live Demo
Frontend (Web App): [Insert Render Frontend URL here]

Backend API (Swagger UI): [Insert Render Backend URL here]/docs

## 🛠️ Tech Stack
Frontend: Flutter (Web), Dart, Fl_Chart, HTTP

Backend Orchestrator: Python, FastAPI, Uvicorn, Pydantic

Deployment: Render (Static Site for Frontend, Web Service for Backend)

AI Architecture Plan: IBM Bob / Groq (Multi-Agent Workflow)

## 💻 Local Setup Guide
## 1. Run the FastAPI Backend
The backend serves as the orchestrator for project analysis and AI fix generation.

Bash
## Navigate to the backend directory
cd backend-folder-name

## Install required dependencies
pip install -r requirements.txt

## Start the local server
uvicorn devflow_api:app --reload
The API will be available at [http://127.0.0.1:8000](http://127.0.0.1:8000).

## 2. Run the Flutter Frontend
The frontend provides a high-fidelity dark mode UI to interact with the DevFlow orchestrator.

Bash
## Navigate to the frontend directory
cd devflow-frontend

## Fetch Flutter packages
flutter pub get

## Run the app locally in Chrome
flutter run -d chrome

## 🏆 48-Hour Hackathon Checklist

- [x] Flutter Material 3 Dashboard & Visual Charts
- [x] FastAPI REST API with complete CRUD & upload pipeline
- [x] Groq `llama-3.3-70b` integration with structured JSON mode
- [x] Zero-RCE Python AST syntax verification
- [x] Zip Slip directory traversal security protection
- [x] Supabase PostgreSQL relational schema & RLS policies
- [x] Realistic flawed `demo-project` for live demonstrations
- [x] Verifiable IBM Bob 2.0 attribution evidence
