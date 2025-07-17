#!/bin/bash
echo "📦 Génération de Sidebar.tsx avec menus dynamiques selon les permissions..."

SIDEBAR_PATH="../apps/admin/src/components/Sidebar.tsx"
mkdir -p "$(dirname "$SIDEBAR_PATH")"

cat > "$SIDEBAR_PATH" <<'EOF'
import { Link } from "react-router-dom";
import { usePermission } from "../context/PermissionProvider";

export default function Sidebar() {
  const { hasPermission } = usePermission();

  const menuItems = [
    { path: "/", label: "🏠 Dashboard", perm: null },
    { path: "/orders", label: "📦 Commandes", perm: "order:read" },
    { path: "/products", label: "🛍️ Produits", perm: "product:read" },
    { path: "/users", label: "👥 Utilisateurs", perm: "user:read" },
    { path: "/settings", label: "⚙️ Paramètres", perm: "settings:access" },
  ];

  return (
    <aside style={{ width: "200px", float: "left", padding: "1rem" }}>
      <ul>
        {menuItems.map(({ path, label, perm }) =>
          perm === null || hasPermission(perm) ? (
            <li key={path}>
              <Link to={path}>{label}</Link>
            </li>
          ) : null
        )}
      </ul>
    </aside>
  );
}
EOF

echo "✅ Sidebar.tsx dynamique générée avec injection des permissions."
