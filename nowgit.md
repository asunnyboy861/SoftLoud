# Git Repositories

## Main App (iOS Application)

| Item | Value |
|------|-------|
| **Repository Name** | SoftLoud |
| **Git URL** | git@github.com:asunnyboy861/SoftLoud.git |
| **Repo URL** | https://github.com/asunnyboy861/SoftLoud |
| **Visibility** | Public |
| **Primary Language** | Swift |
| **GitHub Pages** | ✅ **ENABLED** (from `/docs` folder) |

## Policy Pages (Deployed from Main Repository /docs)

| Page | URL | Status |
|------|-----|--------|
| Landing Page | https://asunnyboy861.github.io/SoftLoud/ | ✅ Deployed |
| Support | https://asunnyboy861.github.io/SoftLoud/support.html | ✅ Deployed |
| Privacy Policy | https://asunnyboy861.github.io/SoftLoud/privacy.html | ✅ Deployed |
| Terms of Use | N/A | ❌ Not needed (paid download model) |

## Repository Structure

```
SoftLoud/
├── SoftLoud/                          # iOS App Source Code
│   ├── SoftLoud.xcodeproj/            # Xcode Project
│   ├── SoftLoud/                      # Swift Source Files
│   │   ├── Views/
│   │   ├── Models/
│   │   ├── ViewModels/
│   │   └── Services/
│   └── ...
├── docs/                              # Policy Pages (GitHub Pages source)
│   ├── index.html                     # Landing Page
│   ├── support.html                   # Support Page
│   └── privacy.html                   # Privacy Policy
├── .github/workflows/
│   └── deploy.yml                     # GitHub Pages deployment
├── us.md                              # English Development Guide
├── keytext.md                         # App Store Metadata
├── capabilities.md                    # Capabilities Configuration
├── icon.md                            # App Icon Details
├── price.md                           # Pricing Configuration
└── nowgit.md                          # This File
```
