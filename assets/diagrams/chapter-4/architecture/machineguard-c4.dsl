workspace "MachineGuard" "Vistas C4 (Sistema, Contexto, Contenedores y Despliegue) del capítulo 4. Estado al 07/11/2026." {

    !identifiers hierarchical

    model {
        jefeAlmacen = person "Jefe de Almacén / Gerente de Operaciones" "Monitorea condiciones ambientales, configura zonas y umbrales, y gestiona alertas e incidentes." "Person"
        encargadoCalidad = person "Encargado de Control de Calidad" "Consulta reportes de trazabilidad y genera evidencia para auditorías." "Person"
        visitante = person "Visitante Web" "Descubre MachineGuard y solicita un piloto gratuito." "Person"

        sensorNodes = softwareSystem "Sensor Nodes (ESP32 + DHT22)" "Nodos físicos de monitoreo instalados en el almacén. Miden temperatura y humedad." "External"
        erp = softwareSystem "ERP del Cliente" "Sistema de gestión empresarial del cliente (SAP, Odoo, etc.) que consume mediciones y reportes con JWT." "External"
        twilio = softwareSystem "Twilio" "Plataforma de notificaciones SMS y WhatsApp. Aplazado; no implementado." "External,Deferred"
        openWeather = softwareSystem "OpenWeatherMap" "API de datos climáticos de referencia. Previsto; no implementado." "External,Planned"
        thingSpeak = softwareSystem "ThingSpeak" "Canal IoT opcional al que el Edge Gateway publica lecturas. Implementado; desactivado por defecto." "External"

        machineGuard = softwareSystem "MachineGuard" "Plataforma SaaS de monitoreo ambiental IoT para PyMEs industriales y logísticas. Detecta excursiones de temperatura y humedad; las notificaciones externas están aplazadas." "System" {
            landingPage = container "Landing Page" "Presenta la propuesta de valor y envía solicitudes de piloto a la API pública." "HTML / CSS / JavaScript (GitHub Pages)" "Client"
            webApp = container "Web App" "Dashboard de monitoreo, configuración de zonas y umbrales, atención de alertas e incidentes, historial y reportes." "Angular 22 (GitHub Pages)" "Client"
            mobileApp = container "Mobile App (aplazada)" "Aplicación móvil prevista; no implementada. Tecnología por definir." "Por definir" "Deferred"
            coreApi = container "RESTful API" "API central con los contextos IAM, Customer Acquisition, Environmental Monitoring, Alert & Incident Management y Traceability & Quality. Documentada con OpenAPI / Swagger." "Java 21 / Spring Boot 4.1.2 / Spring Data JPA" "Container"
            database = container "Base de Datos Central" "Organizaciones, usuarios, sesiones, zonas, mediciones, alertas, incidentes, excursiones y reportes." "PostgreSQL" "Database"

            group "Edge Layer (red del cliente)" {
                edgeApi = container "Edge API" "Procesa lecturas localmente, aplica calibración, mantiene buffer offline y sincroniza con el Core." "Python / Flask + Peewee + SQLite" "Edge"
                embeddedApp = container "Embedded App (Firmware)" "Captura temperatura y humedad del DHT22 cada Sampling Interval y envía las lecturas al Edge." "C++ (Arduino) sobre ESP32 DevKit V1" "Device"
            }
        }

        visitante -> machineGuard.landingPage "Visita y solicita piloto" "HTTPS"
        machineGuard.landingPage -> machineGuard.coreApi "Solicita piloto" "HTTPS / JSON (público)"
        jefeAlmacen -> machineGuard.webApp "Configura y monitorea" "HTTPS"
        jefeAlmacen -> machineGuard.mobileApp "Alertas (aplazado)" "HTTPS" "Deferred"
        encargadoCalidad -> machineGuard.webApp "Consulta trazabilidad" "HTTPS"
        machineGuard.webApp -> machineGuard.coreApi "Consume datos y acciones" "HTTPS / REST, JWT"
        machineGuard.mobileApp -> machineGuard.coreApi "Consume datos (aplazado)" "HTTPS / REST, JWT" "Deferred"
        erp -> machineGuard.coreApi "Consume mediciones y reportes" "REST / JSON, JWT"
        machineGuard.coreApi -> machineGuard.database "Lee y escribe" "JDBC"
        machineGuard.embeddedApp -> machineGuard.edgeApi "Lecturas" "HTTP / JSON"
        machineGuard.edgeApi -> machineGuard.coreApi "Envía mediciones" "HTTPS, X-Device-Credential"
        machineGuard.edgeApi -> thingSpeak "Publica lecturas (opcional)" "HTTPS"
        machineGuard.coreApi -> twilio "Notificaciones (aplazado)" "REST / JSON" "Deferred"
        machineGuard.coreApi -> openWeather "Clima de referencia (previsto)" "REST / JSON" "Planned"
        sensorNodes -> machineGuard "Envía lecturas vía Edge" "HTTP / JSON"

        instalaciones = deploymentEnvironment "Objetivo" {
            clienteLan = deploymentNode "Instalaciones del cliente" "Red LAN del almacén o planta industrial" "Red local" {
                zonaMonitoreo = deploymentNode "Zona de monitoreo" "Hardware físico en el almacén" "" {
                    esp32 = deploymentNode "ESP32 DevKit V1" "Nodo sensor con DHT22" "ESP32" {
                        firmwareInstance = containerInstance machineGuard.embeddedApp
                    }
                }
                gatewayLocal = deploymentNode "Gateway local" "Laptop / PC en pruebas; Raspberry Pi como propuesta" "Python 3.x" {
                    edgeInstance = containerInstance machineGuard.edgeApi
                }
            }
            dispositivoMovil = deploymentNode "Dispositivo móvil del usuario" "Android / iOS" "" {
                movilInstance = containerInstance machineGuard.mobileApp
            }
            gitHubPages = deploymentNode "GitHub Pages" "Hosting estático (despliegue de la Landing y la Web)" "CDN" {
                landingInstance = containerInstance machineGuard.landingPage
                webInstance = containerInstance machineGuard.webApp
            }
            nubeCentral = deploymentNode "Hosting de la API central (por definir)" "Por definir" "Nube" {
                servidorApp = deploymentNode "Servidor de aplicaciones" "JVM 21" "Java / Spring Boot" {
                    coreInstance = containerInstance machineGuard.coreApi
                }
                servidorDb = deploymentNode "Servidor de base de datos" "PostgreSQL" "" {
                    dbInstance = containerInstance machineGuard.database
                }
            }
        }
    }

    views {
        systemLandscape "SystemLandscape" "Visión general de MachineGuard con sus usuarios y sistemas externos." {
            include *
            autoLayout tb 300 200
            title "System Landscape — MachineGuard"
        }

        systemContext machineGuard "SystemContext" "Interacciones de MachineGuard como caja negra con actores y sistemas externos." {
            include *
            autoLayout tb 250 180
            title "Context Diagram — MachineGuard"
        }

        container machineGuard "Containers" "Contenedores de MachineGuard y sus relaciones principales." {
            include *
            exclude sensorNodes
            autoLayout tb 300 200
            title "Container Diagram — MachineGuard"
        }

        deployment machineGuard "Objetivo" "DeploymentMachineGuard" "Despliegue objetivo de MachineGuard." {
            include *
            autoLayout tb 300 200
            title "Deployment Diagram — MachineGuard"
        }

        styles {
            element "Person" {
                shape person
                background #08427B
                color #FFFFFF
            }
            element "System" {
                background #1168BD
                color #FFFFFF
            }
            element "Container" {
                background #438DD5
                color #FFFFFF
            }
            element "Client" {
                background #438DD5
                color #FFFFFF
            }
            element "Edge" {
                background #438DD5
                color #FFFFFF
            }
            element "Device" {
                background #438DD5
                color #FFFFFF
            }
            element "Database" {
                shape cylinder
                background #438DD5
                color #FFFFFF
            }
            element "External" {
                background #999999
                color #FFFFFF
            }
            element "Deferred" {
                background #E5E7EB
                color #6B7280
                border dashed
            }
            element "Planned" {
                background #E5E7EB
                color #6B7280
                border dashed
            }
            element "Software System" {
                background #1168BD
                color #FFFFFF
            }
            relationship "Deferred" {
                dashed true
                color #9CA3AF
            }
            relationship "Planned" {
                dashed true
                color #9CA3AF
            }
        }
    }

    configuration {
        scope softwaresystem
    }
}
