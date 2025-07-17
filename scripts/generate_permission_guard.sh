#!/bin/bash
echo "🔐 Génération du composant PermissionGuard sacré..."

GUARD_PATH="../apps/admin/src/guards/PermissionGuard.tsx"
HOOK_PATH="../apps/admin/src/hooks/useAuth.ts"

mkdir -p "$(dirname $GUARD_PATH)"

cat > "$GUARD_PATH" <<'EOF'
import { useAuth } from "../hooks/useAuth";

interface PermissionGuardProps {
  permission: string;
  children: JSX.Element;
}

export default function PermissionGuard({ permission, children }: PermissionGuardProps) {
  const { user, hasPermission } = useAuth();

  if (!user || !hasPermission(permission)) {
    return null; // UI masquée si non autorisé
  }

  return children;
}
EOF

echo "✅ PermissionGuard.tsx généré."

if [ ! -f "$HOOK_PATH" ]; then
  echo "⚠️ Le hook useAuth.ts est introuvable à $HOOK_PATH."
else
  echo "🧬 Le hook useAuth existe : vérifie qu’il contient la méthode hasPermission()."
fi
