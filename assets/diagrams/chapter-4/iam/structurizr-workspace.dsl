workspace "MachineGuard - IAM" "C4 Component view for the Identity and Access Management bounded context" {

    !identifiers hierarchical

    model {
        organizationUser = person "Organization User" "Warehouse Manager or Quality Manager who uses MachineGuard."

        machineGuard = softwareSystem "MachineGuard" "SaaS and IoT platform for continuous environmental monitoring." {
            webApp = container "Web App" "Dashboard for monitoring, configuration and traceability." "Angular" "Client"
            mobileApp = container "Mobile App" "Mobile monitoring and alert application." "Kotlin / Flutter" "Client"
            database = container "Central Database" "Stores organizations, users and authentication sessions." "PostgreSQL" "Database"

            restApi = container "RESTful API" "Central API that hosts the MachineGuard bounded contexts." "Spring Boot" {
                group "IAM - Interface Layer" {
                    iamApi = component "IAM REST API" "AuthController, UserController, OrganizationController, resources and assemblers." "Spring MVC" "IAM,Interface"
                    authenticationFilter = component "Authentication Filter" "Validates JWT access tokens before protected requests reach the controllers." "Spring Security" "IAM,Interface"
                    tenantContextResolver = component "Tenant Context Resolver" "Derives userId, organizationId and role from validated token claims." "Spring Security" "IAM,Interface"
                    pilotRequestConsumer = component "Pilot Request Consumer" "Consumes PilotRequestSubmitted and translates it into an IAM onboarding command." "Spring Event Consumer" "IAM,Interface"
                }

                group "IAM - Application Layer" {
                    commandServices = component "Command Services" "Create organization, register user, login, logout, assign role and reset password use cases." "Spring Service" "IAM,Application"
                    queryServices = component "Query Services" "User profile, organization and token validation queries." "Spring Service" "IAM,Application"
                    securityPorts = component "Security Ports" "PasswordHasher and TokenProvider abstractions used by IAM use cases." "Java Interfaces" "IAM,Application"
                }

                group "IAM - Domain Layer" {
                    domainModel = component "IAM Domain Model" "Organization and User aggregate roots, AuthenticationSession entity and IAM value objects." "Java" "IAM,Domain"
                    domainPolicies = component "Domain Policies" "UserRegistrationPolicy and RoleAssignmentPolicy enforce IAM invariants." "Java" "IAM,Domain"
                    repositoryPorts = component "Repository Ports" "OrganizationRepository, UserRepository and AuthenticationSessionRepository abstractions." "Java Interfaces" "IAM,Domain"
                }

                group "IAM - Infrastructure Layer" {
                    persistenceAdapters = component "Persistence Adapters" "JPA adapters that implement the IAM repository ports." "Spring Data JPA" "IAM,Infrastructure"
                    securityAdapters = component "Security Adapters" "JwtTokenProvider and BCryptPasswordHasher implementations." "Spring Security / JWT" "IAM,Infrastructure"
                    eventPublisher = component "IAM Event Publisher" "Publishes organization, user, authentication and role domain events." "Spring Events" "IAM,Infrastructure"
                }

                group "Other Bounded Contexts" {
                    customerAcquisition = component "Customer Acquisition" "Captures pilot requests from the landing page." "Spring Boot" "OtherBC"
                    environmentalMonitoring = component "Environmental Monitoring" "Manages monitored facilities, zones, points, thresholds and measurements." "Spring Boot" "OtherBC"
                    alertIncident = component "Alert & Incident Management" "Manages alerts, acknowledgements, escalations and corrective actions." "Spring Boot" "OtherBC"
                    traceabilityQuality = component "Traceability & Quality" "Maintains environmental excursions and traceability reports." "Spring Boot" "OtherBC"
                }
            }
        }

        organizationUser -> machineGuard.webApp "Uses" "HTTPS"
        organizationUser -> machineGuard.mobileApp "Uses" "HTTPS"

        machineGuard.webApp -> machineGuard.restApi.iamApi "Authenticates and manages the organization" "REST/JSON over HTTPS"
        machineGuard.mobileApp -> machineGuard.restApi.iamApi "Authenticates and reads the user profile" "REST/JSON over HTTPS"
        machineGuard.webApp -> machineGuard.restApi.authenticationFilter "Sends access token" "JWT"
        machineGuard.mobileApp -> machineGuard.restApi.authenticationFilter "Sends access token" "JWT"

        machineGuard.restApi.authenticationFilter -> machineGuard.restApi.queryServices "Requests token validation"
        machineGuard.restApi.authenticationFilter -> machineGuard.restApi.tenantContextResolver "Supplies validated claims"
        machineGuard.restApi.tenantContextResolver -> machineGuard.restApi.iamApi "Supplies authenticated tenant context"
        machineGuard.restApi.tenantContextResolver -> machineGuard.restApi.environmentalMonitoring "Supplies organizationId and role"
        machineGuard.restApi.tenantContextResolver -> machineGuard.restApi.alertIncident "Supplies organizationId and role"
        machineGuard.restApi.tenantContextResolver -> machineGuard.restApi.traceabilityQuality "Supplies organizationId and role"

        machineGuard.restApi.customerAcquisition -> machineGuard.restApi.pilotRequestConsumer "Publishes PilotRequestSubmitted" "Domain Event"
        machineGuard.restApi.pilotRequestConsumer -> machineGuard.restApi.commandServices "Starts organization onboarding"

        machineGuard.restApi.iamApi -> machineGuard.restApi.commandServices "Executes commands"
        machineGuard.restApi.iamApi -> machineGuard.restApi.queryServices "Executes queries"
        machineGuard.restApi.commandServices -> machineGuard.restApi.domainPolicies "Evaluates business rules"
        machineGuard.restApi.commandServices -> machineGuard.restApi.domainModel "Changes aggregate state"
        machineGuard.restApi.commandServices -> machineGuard.restApi.repositoryPorts "Loads and persists aggregates"
        machineGuard.restApi.commandServices -> machineGuard.restApi.securityPorts "Hashes passwords and issues tokens"
        machineGuard.restApi.commandServices -> machineGuard.restApi.eventPublisher "Publishes domain events"
        machineGuard.restApi.queryServices -> machineGuard.restApi.repositoryPorts "Reads identities and organizations"
        machineGuard.restApi.queryServices -> machineGuard.restApi.securityPorts "Validates token signature and claims"
        machineGuard.restApi.domainPolicies -> machineGuard.restApi.domainModel "Enforces invariants"

        machineGuard.restApi.persistenceAdapters -> machineGuard.restApi.repositoryPorts "Implements"
        machineGuard.restApi.persistenceAdapters -> machineGuard.database "Reads from and writes to" "JDBC/SQL"
        machineGuard.restApi.securityAdapters -> machineGuard.restApi.securityPorts "Implements"
        machineGuard.restApi.eventPublisher -> machineGuard.restApi.environmentalMonitoring "Publishes OrganizationCreated" "Domain Event"
        machineGuard.restApi.eventPublisher -> machineGuard.restApi.alertIncident "Publishes identity context" "Published Language"
        machineGuard.restApi.eventPublisher -> machineGuard.restApi.traceabilityQuality "Publishes identity context" "Published Language"
    }

    views {
        component machineGuard.restApi "IamComponentView" "Components of the IAM bounded context and their principal collaborators." {
            include *
            autoLayout tb 300 200
            title "C4 Component Diagram - IAM (Identity & Access Management)"
        }

        styles {
            element "Person" {
                shape person
                background #08427B
                color #FFFFFF
            }
            element "Client" {
                background #438DD5
                color #FFFFFF
            }
            element "Database" {
                shape cylinder
                background #1168BD
                color #FFFFFF
            }
            element "Interface" {
                background #D9EAF7
                color #172B4D
            }
            element "Application" {
                background #FFF1BE
                color #172B4D
            }
            element "Domain" {
                background #F8D7DA
                color #172B4D
            }
            element "Infrastructure" {
                background #DFF2F2
                color #172B4D
            }
            element "OtherBC" {
                background #B7E4C7
                color #172B4D
            }
            relationship "Relationship" {
                routing orthogonal
                color #4A5568
            }
        }
    }

    configuration {
        scope softwaresystem
    }
}
