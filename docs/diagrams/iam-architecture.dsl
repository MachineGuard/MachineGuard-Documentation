workspace "MachineGuard IAM" "IAM component architecture." {
    model {
        admin = person "Organization Administrator" "Manages users in an organization."
        machineguard = softwareSystem "MachineGuard" "IoT platform for organization and device management." {
            api = container "MachineGuard Core API" "REST API for IAM and traceability." "Spring Boot 3.5 / Java 21" {
                rest = component "IAM REST Controllers" "AuthController, UserController and OrganizationController." "Spring MVC"
                service = component "IamService" "Authentication and tenant administration use cases." "Spring"
                domain = component "IAM Domain Model" "Organizations, users, sessions, invitations and role rules." "Java"
                ports = component "Repository Ports" "Contracts for IAM persistence." "Java interfaces"
                jpa = component "JPA Adapters" "Maps domain objects to PostgreSQL." "Spring Data JPA"
                tokens = component "JWT Token Adapter" "Signs access tokens and hashes opaque tokens." "Spring Security"
                passwords = component "Password Hasher" "Hashes and verifies user passwords." "BCrypt"
                handlers = component "IAM Event and Bootstrap Handlers" "Processes pilot requests and one-time local bootstrap." "Spring"
            }
            postgres = container "PostgreSQL" "IAM and traceability persistence." "PostgreSQL 16" {
                tags "Database"
            }
        }
        admin -> api "Manages users through" "HTTPS/REST"
        rest -> service "Calls"
        service -> domain "Applies business rules"
        service -> ports "Uses"
        ports -> jpa "Implemented by"
        jpa -> postgres "Reads and writes" "JDBC"
        service -> tokens "Issues and validates tokens"
        service -> passwords "Hashes and verifies passwords"
        handlers -> service "Starts IAM use cases"
    }
    views {
        component api "iam-components" "IAM components in MachineGuard Core API" {
            include *
            include postgres
            autoLayout lr
        }
        styles {
            element "Person" {
                shape person
            }
            element "Database" {
                shape cylinder
            }
        }
    }
}
