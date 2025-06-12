#!/bin/bash

echo "🔓 A desbloquear features enterprise do Infisical..."

# Backup dos ficheiros originais
echo "📦 A criar backups..."
cp backend/src/ee/services/license/license-fns.ts backend/src/ee/services/license/license-fns.ts.backup
cp backend/src/services/secret-sync/secret-sync-fns.ts backend/src/services/secret-sync/secret-sync-fns.ts.backup
cp backend/src/services/app-connection/app-connection-fns.ts backend/src/services/app-connection/app-connection-fns.ts.backup

# 1. Desbloquear todas as features em license-fns.ts
echo "🚀 A alterar features padrão..."
sed -i 's/dynamicSecret: false,/dynamicSecret: true,/g' backend/src/ee/services/license/license-fns.ts
sed -i 's/secretRotation: false,/secretRotation: true,/g' backend/src/ee/services/license/license-fns.ts
sed -i 's/secretApproval: false,/secretApproval: true,/g' backend/src/ee/services/license/license-fns.ts
sed -i 's/rbac: false,/rbac: true,/g' backend/src/ee/services/license/license-fns.ts
sed -i 's/ipAllowlisting: false,/ipAllowlisting: true,/g' backend/src/ee/services/license/license-fns.ts
sed -i 's/githubOrgSync: false,/githubOrgSync: true,/g' backend/src/ee/services/license/license-fns.ts
sed -i 's/customRateLimits: false,/customRateLimits: true,/g' backend/src/ee/services/license/license-fns.ts
sed -i 's/customAlerts: false,/customAlerts: true,/g' backend/src/ee/services/license/license-fns.ts
sed -i 's/secretAccessInsights: false,/secretAccessInsights: true,/g' backend/src/ee/services/license/license-fns.ts
sed -i 's/auditLogs: false,/auditLogs: true,/g' backend/src/ee/services/license/license-fns.ts
sed -i 's/auditLogStreams: false,/auditLogStreams: true,/g' backend/src/ee/services/license/license-fns.ts
sed -i 's/samlSSO: false,/samlSSO: true,/g' backend/src/ee/services/license/license-fns.ts
sed -i 's/hsm: false,/hsm: true,/g' backend/src/ee/services/license/license-fns.ts
sed -i 's/oidcSSO: false,/oidcSSO: true,/g' backend/src/ee/services/license/license-fns.ts
sed -i 's/scim: false,/scim: true,/g' backend/src/ee/services/license/license-fns.ts
sed -i 's/ldap: false,/ldap: true,/g' backend/src/ee/services/license/license-fns.ts
sed -i 's/groups: false,/groups: true,/g' backend/src/ee/services/license/license-fns.ts
sed -i 's/caCrl: false,/caCrl: true,/g' backend/src/ee/services/license/license-fns.ts
sed -i 's/instanceUserManagement: false,/instanceUserManagement: true,/g' backend/src/ee/services/license/license-fns.ts
sed -i 's/externalKms: false,/externalKms: true,/g' backend/src/ee/services/license/license-fns.ts
sed -i 's/pkiEst: false,/pkiEst: true,/g' backend/src/ee/services/license/license-fns.ts
sed -i 's/enforceMfa: false,/enforceMfa: true,/g' backend/src/ee/services/license/license-fns.ts
sed -i 's/projectTemplates: false,/projectTemplates: true,/g' backend/src/ee/services/license/license-fns.ts
sed -i 's/kmip: false,/kmip: true,/g' backend/src/ee/services/license/license-fns.ts
sed -i 's/gateway: false,/gateway: true,/g' backend/src/ee/services/license/license-fns.ts
sed -i 's/sshHostGroups: false,/sshHostGroups: true,/g' backend/src/ee/services/license/license-fns.ts
sed -i 's/secretScanning: false,/secretScanning: true,/g' backend/src/ee/services/license/license-fns.ts
sed -i 's/enterpriseSecretSyncs: false,/enterpriseSecretSyncs: true,/g' backend/src/ee/services/license/license-fns.ts
sed -i 's/enterpriseAppConnections: false/enterpriseAppConnections: true/g' backend/src/ee/services/license/license-fns.ts

# Aumentar limites
sed -i 's/readLimit: 60,/readLimit: 1000,/g' backend/src/ee/services/license/license-fns.ts
sed -i 's/writeLimit: 200,/writeLimit: 1000,/g' backend/src/ee/services/license/license-fns.ts
sed -i 's/secretsLimit: 40/secretsLimit: 1000/g' backend/src/ee/services/license/license-fns.ts
sed -i 's/auditLogsRetentionDays: 0,/auditLogsRetentionDays: 365,/g' backend/src/ee/services/license/license-fns.ts

# 2. Remover verificações enterprise em secret-sync
echo "🔧 A remover verificações de secret sync..."
cat > temp_secret_sync.ts << 'EOF'
export const enterpriseSyncCheck = async (
  licenseService: Pick<TLicenseServiceFactory, "getPlan">,
  secretSync: SecretSync,
  orgId: string,
  errorMessage: string
) => {
  // ✅ Enterprise features unlocked - all sync types allowed
  return;
};
EOF

# Substituir a função enterpriseSyncCheck
sed -i '/export const enterpriseSyncCheck = async (/,/^};$/c\
export const enterpriseSyncCheck = async (\
  licenseService: Pick<TLicenseServiceFactory, "getPlan">,\
  secretSync: SecretSync,\
  orgId: string,\
  errorMessage: string\
) => {\
  \/\/ ✅ Enterprise features unlocked - all sync types allowed\
  return;\
};' backend/src/services/secret-sync/secret-sync-fns.ts

# 3. Remover verificações enterprise em app-connection
echo "🔧 A remover verificações de app connection..."
sed -i '/export const enterpriseAppCheck = async (/,/^};$/c\
export const enterpriseAppCheck = async (\
  licenseService: Pick<TLicenseServiceFactory, "getPlan">,\
  appConnection: AppConnection,\
  orgId: string,\
  errorMessage: string\
) => {\
  \/\/ ✅ Enterprise features unlocked - all app connections allowed\
  return;\
};' backend/src/services/app-connection/app-connection-fns.ts

# 4. Criar marca para indicar que foi modificado
echo "🏷️ A marcar versão modificada..."
echo "// 🔓 INFISICAL ENTERPRISE FEATURES UNLOCKED - Modified by filipecabrita" >> backend/src/ee/services/license/license-fns.ts

# Cleanup
rm -f temp_secret_sync.ts

echo "✅ Features enterprise desbloqueadas com sucesso!"
echo "📝 Backups criados em *.backup"
echo "🐳 Para construir: docker build -t filipecabrita/infisical-unlocked ."

# Verificar se as alterações foram aplicadas
echo ""
echo "🔍 Verificação rápida:"
if grep -q "dynamicSecret: true" backend/src/ee/services/license/license-fns.ts; then
    echo "✅ Dynamic secrets: desbloqueado"
else
    echo "❌ Dynamic secrets: falhou"
fi

if grep -q "secretRotation: true" backend/src/ee/services/license/license-fns.ts; then
    echo "✅ Secret rotation: desbloqueado" 
else
    echo "❌ Secret rotation: falhou"
fi

if grep -q "Enterprise features unlocked" backend/src/services/secret-sync/secret-sync-fns.ts; then
    echo "✅ Secret sync checks: removidos"
else
    echo "❌ Secret sync checks: falhou"
fi
