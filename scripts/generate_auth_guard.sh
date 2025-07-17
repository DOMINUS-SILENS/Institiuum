import AuthGuard from "./guards/AuthGuard";
<Route path="/orders" element={
  <AuthGuard requiredRole="admin">
    <Orders />
  </AuthGuard>
} />
