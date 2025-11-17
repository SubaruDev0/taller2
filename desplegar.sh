#!/bin/bash
# Script de despliegue rápido
echo "════════════════════════════════════════════════════════════════════"
echo "           🚀 DESPLEGANDO APLICACIÓN TALLER 2"
echo "════════════════════════════════════════════════════════════════════"
echo ""

export GLASSFISH_HOME=/opt/glassfish6/glassfish
export PATH=$GLASSFISH_HOME/bin:$PATH
cd /home/subaru/Escritorio/Proyectos/Taller2

# Compilar con Java 11 explícitamente
echo "📦 Compilando con Java 11..."
if [ -d "/usr/lib/jvm/java-11-openjdk-amd64" ]; then
    JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64 mvn clean package -q
else
    echo "⚠️  Java 11 no encontrado, instalando..."
    sudo apt install -y openjdk-11-jdk > /dev/null 2>&1
    JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64 mvn clean package -q
fi
echo "✓ Compilación completa"
echo ""

echo "📋 Verificando estado de GlassFish..."
asadmin list-domains
echo ""

echo "🔧 Configurando puerto 9000..."
asadmin set configs.config.server-config.network-config.network-listeners.network-listener.http-listener-1.port=9000 > /dev/null 2>&1
echo "✓ Puerto configurado"
echo ""

echo "🔄 Reiniciando GlassFish..."
asadmin restart-domain domain1
echo ""

echo "⏳ Esperando que GlassFish reinicie..."
sleep 5
echo ""

echo "📦 Desplegando taller2.war..."
asadmin deploy --force=true target/taller2.war
DEPLOY_STATUS=$?
echo ""

echo "✅ Verificando aplicaciones desplegadas:"
asadmin list-applications
echo ""

if [ $DEPLOY_STATUS -eq 0 ]; then
    echo "════════════════════════════════════════════════════════════════════"
    echo "                  ✨ ¡DESPLIEGUE EXITOSO! ✨"
    echo "════════════════════════════════════════════════════════════════════"
    echo ""
    echo "🌐 Accede a tu aplicación en:"
    echo ""
    echo "   👉 http://localhost:9000/taller2/"
    echo ""
else
    echo "════════════════════════════════════════════════════════════════════"
    echo "                  ❌ ERROR EN EL DESPLIEGUE"
    echo "════════════════════════════════════════════════════════════════════"
    echo ""
    echo "Ejecuta el script de solución:"
    echo "  ./solucionar_java.sh"
    echo ""
    echo "Ver logs completos:"
    echo "  tail -50 /opt/glassfish6/glassfish/domains/domain1/logs/server.log"
    echo ""
fi

echo "🔧 Consola de administración:"
echo ""
echo "   http://localhost:4848"
echo ""
echo "════════════════════════════════════════════════════════════════════"

