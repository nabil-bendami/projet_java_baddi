# Presence Management Backend - Java Spring Boot

Backend complet pour l'application de gestion de présence.

## Stack Technique
- **Java**: 17
- **Spring Boot**: 3.2.0
- **Maven**: Build tool
- **Base de données**: H2 (par défaut) / MySQL (optionnel)
- **Sécurité**: Spring Security + JWT
- **ORM**: Spring Data JPA

## Structure du Projet

```
presence-backend/
├── src/main/java/ma/estsb/presencebackend/
│   ├── PresenceBackendApplication.java          # Main class
│   ├── model/                                    # Entités JPA
│   │   ├── User.java
│   │   ├── Student.java
│   │   ├── Session.java
│   │   ├── Attendance.java
│   │   └── enums/
│   │       ├── UserRole.java
│   │       └── AttendanceStatus.java
│   ├── repository/                               # Repositories JPA
│   │   ├── UserRepository.java
│   │   ├── StudentRepository.java
│   │   ├── SessionRepository.java
│   │   └── AttendanceRepository.java
│   ├── dto/                                      # Data Transfer Objects
│   │   ├── LoginRequest.java
│   │   ├── LoginResponse.java
│   │   └── AttendanceMarkRequest.java
│   ├── security/                                 # Configuration sécurité
│   │   ├── JwtUtil.java
│   │   ├── JwtAuthenticationFilter.java         # À créer (Batch 4)
│   │   ├── SecurityConfig.java                  # À créer (Batch 4)
│   │   └── CustomUserDetailsService.java        # À créer (Batch 4)
│   ├── service/                                  # Services métier (Batch 4)
│   │   ├── AuthService.java
│   │   ├── StudentService.java
│   │   ├── SessionService.java
│   │   └── AttendanceService.java
│   ├── controller/                               # REST Controllers (Batch 5)
│   │   ├── AuthController.java
│   │   ├── UserController.java
│   │   ├── StudentController.java
│   │   ├── SessionController.java
│   │   └── AttendanceController.java
│   ├── exception/                                # Gestion des exceptions (Batch 5)
│   │   ├── GlobalExceptionHandler.java
│   │   └── ResourceNotFoundException.java
│   └── config/                                   # Configurations (Batch 4)
│       ├── CorsConfig.java
│       └── DataSeeder.java
├── src/main/resources/
│   └── application.yml                           # Configuration
├── pom.xml                                       # Maven dependencies
└── README.md

```

## Configuration Base de Données

### H2 (Par défaut - Développement)
```yaml
spring:
  datasource:
    url: jdbc:h2:mem:presencedb
    driver-class-name: org.h2.Driver
    username: sa
    password: 
  h2:
    console:
      enabled: true
      path: /h2-console
```

Console H2: http://localhost:8080/api/h2-console

### MySQL (Production)
Décommenter dans `application.yml`:
```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/presencedb?createDatabaseIfNotExist=true
    driver-class-name: com.mysql.cj.jdbc.Driver
    username: root
    password: your_password
  jpa:
    properties:
      hibernate:
        dialect: org.hibernate.dialect.MySQLDialect
```

## API Endpoints

### Authentication
- `POST /api/auth/login` - Connexion utilisateur
- `POST /api/auth/register` - Inscription (optionnel)

### Users
- `GET /api/users/me` - Profil utilisateur connecté

### Students (ADMIN)
- `GET /api/students` - Liste des étudiants
- `POST /api/students` - Créer un étudiant
- `GET /api/students/{id}` - Détails d'un étudiant
- `PUT /api/students/{id}` - Modifier un étudiant
- `DELETE /api/students/{id}` - Supprimer un étudiant

### Sessions (ADMIN/PROF)
- `GET /api/sessions?group=GroupeA` - Liste des sessions
- `POST /api/sessions` - Créer une session
- `GET /api/sessions/{id}` - Détails d'une session
- `PUT /api/sessions/{id}` - Modifier une session
- `DELETE /api/sessions/{id}` - Supprimer une session

### Attendance (PROF)
- `POST /api/attendance/mark` - Marquer les présences
- `GET /api/attendance/session/{sessionId}` - Présences d'une session
- `GET /api/attendance/student/{studentId}` - Présences d'un étudiant

## Sécurité

### Rôles
- **ADMIN**: Accès complet
- **PROF**: Gestion des sessions et présences
- **STUDENT**: Lecture seule (ses présences)

### JWT Token
- Durée de validité: 24 heures
- Header: `Authorization: Bearer <token>`

## Installation et Lancement

### Prérequis
- Java 17 ou supérieur
- Maven 3.6+

### Commandes

1. **Naviguer vers le projet**
```bash
cd presence-project/backend_java/presence-backend
```

2. **Compiler le projet**
```bash
mvn clean install
```

3. **Lancer l'application**
```bash
mvn spring-boot:run
```

L'application démarre sur: **http://localhost:8080/api**

## Données de Test

Au démarrage, les données suivantes sont créées automatiquement:

### Utilisateurs
- **Admin**: admin@estsb.ma / password
- **Professeur**: prof@estsb.ma / password
- **Étudiant**: student@estsb.ma / password

### Étudiants
- 10 étudiants avec CNE et groupes variés

### Sessions
- 3 sessions de cours avec différents modules

### Présences
- Quelques enregistrements de présence pour démonstration

## Tests avec cURL

### Login
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"admin@estsb.ma\",\"password\":\"password\"}"
```

### Récupérer les étudiants (avec token)
```bash
curl -X GET http://localhost:8080/api/students \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

### Créer un étudiant
```bash
curl -X POST http://localhost:8080/api/students \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -H "Content-Type: application/json" \
  -d "{\"fullName\":\"Ahmed Alami\",\"cne\":\"R123456789\",\"groupName\":\"Groupe A\"}"
```

## Tests avec Postman

1. Importer la collection (à créer)
2. Configurer l'environnement:
   - `base_url`: http://localhost:8080/api
   - `token`: (sera rempli après login)

## CORS Configuration

CORS activé pour:
- http://localhost:3000
- http://localhost:8081
- http://10.0.2.2:8080 (Flutter emulator)
- http://10.0.2.2:3000

## Prochaines Étapes

### BATCH 4 (À créer)
- SecurityConfig
- JwtAuthenticationFilter
- CustomUserDetailsService
- Services métier
- CorsConfig
- DataSeeder

### BATCH 5 (À créer)
- Controllers REST
- Exception handling
- Validation

## Support

Pour toute question ou problème, consulter la documentation Spring Boot:
https://spring.io/projects/spring-boot

---

**Version**: 1.0.0  
**Auteur**: ESTSB Development Team  
**Date**: 2024
