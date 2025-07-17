#!/bin/bash
echo "🔧 Correction sacrée de Layout.tsx avec routes internes..."

LAYOUT_PATH="apps/admin/src/layouts/Layout.tsx"
PAGES_DIR="apps/admin/src/pages"
COMPONENTS_DIR="apps/admin/src/components"

mkdir -p "$PAGES_DIR"
mkdir -p "$COMPONENTS_DIR"
mkdir -p "$(dirname $LAYOUT_PATH)"

# 🧱 Génère Dashboard.tsx
cat > "$PAGES_DIR/Dashboard.tsx" <<EOF
export default function Dashboard() {
  return (
    <div>
      <h1>📊 Tableau de bord Admin</h1>
      <p>Bienvenue dans votre espace sacré de gestion.</p>
    </div>
  );
}
EOF

# 🧱 Génère Orders.tsx
cat > "$PAGES_DIR/Orders.tsx" <<EOF
export default function Orders() {
  return (
    <div>
      <h1>📦 Commandes</h1>
      <p>Liste de toutes les commandes reçues.</p>
    </div>
  );
}
EOF

# 🧱 Génère Navbar.tsx
cat > "$COMPONENTS_DIR/Navbar.tsx" <<EOF
export default function Navbar() {
  return (
    <nav style={{ backgroundColor: "#222", color: "#fff", padding: "1rem" }}>
      <h2>🛡️ COMMERCIUM ADMIN</h2>
    </nav>
  );
}
EOF

# 🧱 Génère Sidebar.tsx
cat > "$COMPONENTS_DIR/Sidebar.tsx" <<EOF
import { Link } from "react-router-dom";

export default function Sidebar() {
  return (
    <aside style={{ width: "200px", float: "left", padding: "1rem" }}>
      <ul>
        <li><Link to="/">🏠 Dashboard</Link></li>
        <li><Link to="/orders">📦 Commandes</Link></li>
      </ul>
    </aside>
  );
}
EOF

# 🧱 Génère Layout.tsx
cat > "$LAYOUT_PATH" <<EOF
import { Routes, Route } from "react-router-dom";
import Dashboard from "../pages/Dashboard";
import Orders from "../pages/Orders";
import Sidebar from "../components/Sidebar";
import Navbar from "../components/Navbar";

export default function Layout() {
  return (
    <div>
      <Navbar />
      <div style={{ display: "flex" }}>
        <Sidebar />
        <main style={{ marginLeft: "200px", padding: "1rem" }}>
          <Routes>
            <Route path="/" element={<Dashboard />} />
            <Route path="/orders" element={<Orders />} />
          </Routes>
        </main>
      </div>
    </div>
  );
}
EOF

echo "✅ Layout.tsx corrigé et fonctionnel !"
