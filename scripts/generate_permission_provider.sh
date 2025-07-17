#!/bin/bash
echo "🔄 Génération du PermissionProvider sacré..."

PROVIDER_PATH="../apps/admin/src/context/PermissionProvider.tsx"
HOOK_PATH="../apps/admin/src/hooks/useAuth.ts"
mkdir -p "$(dirname "$PROVIDER_PATH")"

cat > "$PROVIDER_PATH" <<'EOF'
import { createContext, useContext, ReactNode } from "react";
import { useAuth } from "../hooks/useAuth";

interface PermissionContextValue {
  hasPermission: (permission: string) => boolean;
}

const PermissionContext = createContext<PermissionContextValue>({
  hasPermission: () => false,
});

export function usePermission() {
  return useContext(PermissionContext);
}

export function PermissionProvider({ children }: { children: ReactNode }) {
  const { user } = useAuth();

  const hasPermission = (permission: string): boolean => {
    if (!user || !user.permissions) return false;
    return user.permissions.includes(permission);
  };

  return (
    <PermissionContext.Provider value={{ hasPermission }}>
      {children}
    </PermissionContext.Provider>
  );
}
EOF

echo "✅ PermissionProvider.tsx généré."

if [ ! -f "$HOOK_PATH" ]; then
  echo "⚠️ Le hook useAuth.ts est manquant. Crée-le avant d'utiliser ce provider."
else
  echo "🧬 Hook useAuth détecté. Prêt pour l'injection contextuelle."
fi
