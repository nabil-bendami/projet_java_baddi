# 🚀 GUIDE D'INSTALLATION ET TEST - Backend Java Spring Boot

## ⚠️ PRÉREQUIS À INSTALLER

### 1. Java 17 (JDK)
**Vérifier si installé:**
```bash
java -version
```

**Si pas installé, télécharger:**
- 🔗 https://adoptium.net/temurin/releases/?version=17
- Choisir: **Windows x64 JDK .msi**
- Installer et redémarrer le terminal

### 2. Maven
**Vérifier si installé:**
```bash
mvn -version
```

**Si pas installé:**

**Option A: Avec Chocolatey (Recommandé)**
```powershell
# Installer Chocolatey si pas déjà fait
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Installer Maven
choco install maven
```

**Option B: Installation Manuelle**
1. Télécharger: https://maven.apache.org/download.cgi
2. Extraire dans `C:\Program Files\Apache\maven`
3. Ajouter au PATH:
   - Ouvrir "Variables d'environnement"
   - Ajouter `C:\Program Files\Apache\maven\bin` au PATH
   - Redémarrer le terminal

---

## 📦 ÉTAPE 1: COMPILER LE PROJET

### Ouvrir PowerShell dans le dossier du projet:
```powershell
cd C:\Users\YLS\Documents\presence-project\backend_java\presence-backend
```

### Compiler et télécharger les dépendances:
```powershell
mvn clean install -DskipTests
```

**⏱️ Première fois: 2-5 minutes** (téléchargement des dépendances)

**✅ Succès si vous voyez:**
```
[INFO] BUILD SUCCESS
[INFO] Total time: XX s
```

**❌ Si erreurs:**
- Vérifier que Java 17 est installé: `java -version`
- Vérifier que Maven est installé: `mvn -version`
- Vérifier le pom.xml (doit être valide XML)

---

## 🚀 ÉTAPE 2: LANCER L'APPLICATION

```powershell
mvn spring-boot:run
```

**✅ Succès si vous voyez:**
```
✅ Data seeding completed successfully!
📧 Admin: admin@estsb.ma / password
📧 Prof: prof@estsb.ma / password
📧 Student: student@estsb.ma / password

Started PresenceBackendApplication in X.XXX seconds (JVM running for X.XXX)
```

**🎯 Backend disponible sur:** `http://localhost:8080/api`

**Pour arrêter:** `Ctrl + C`

---

## 🧪 ÉTAPE 3: TESTER LES ENDPOINTS

### Test 1: Login (Admin)
```powershell
curl -X POST http://localhost:8080/api/auth/login `
  -H "Content-Type: application/json" `
  -d '{\"email\":\"admin@estsb.ma\",\"password\":\"password\"}'
```

**✅ Réponse attendue:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "fullName": "Admin User",
    "email": "admin@estsb.ma",
    "role": "ADMIN"
  }
}
```

**📝 Copier le token pour les tests suivants**

---

### Test 2: Récupérer les étudiants
```powershell
# Remplacer YOUR_TOKEN par le token obtenu
curl -X GET http://localhost:8080/api/students `
  -H "Authorization: Bearer YOUR_TOKEN"
```

**✅ Réponse attendue:** Liste de 10 étudiants

---

### Test 3: Créer un étudiant
```powershell
curl -X POST http://localhost:8080/api/students `
  -H "Authorization: Bearer YOUR_TOKEN" `
  -H "Content-Type: application/json" `
  -d '{\"fullName\":\"Test Student\",\"cne\":\"R999999999\",\"groupName\":\"Groupe A\"}'
```

**✅ Réponse attendue:** L'étudiant créé avec son ID

---

### Test 4: Récupérer les sessions
```powershell
curl -X GET http://localhost:8080/api/sessions `
  -H "Authorization: Bearer YOUR_TOKEN"
```

**✅ Réponse attendue:** Liste de 3 sessions

---

### Test 5: Marquer les présences
```powershell
curl -X POST http://localhost:8080/api/attendance/mark `
  -H "Authorization: Bearer YOUR_TOKEN" `
  -H "Content-Type: application/json" `
  -d '{\"sessionId\":1,\"records\":[{\"studentId\":1,\"status\":\"PRESENT\"},{\"studentId\":2,\"status\":\"ABSENT\"}]}'
```

**✅ Réponse attendue:** Liste des présences créées

---

## 🗄️ ÉTAPE 4: ACCÉDER À LA BASE DE DONNÉES H2

**URL:** http://localhost:8080/api/h2-console

**Connexion:**
- **JDBC URL:** `jdbc:h2:mem:presencedb`
- **Username:** `sa`
- **Password:** *(laisser vide)*

**Tables disponibles:**
- USERS
- STUDENTS
- SESSIONS
- ATTENDANCE

---

## 🔧 DÉPANNAGE

### Erreur: "Port 8080 already in use"
```powershell
# Trouver le processus
netstat -ano | findstr :8080

# Tuer le processus (remplacer PID)
taskkill /PID <PID> /F
```

### Erreur: "JAVA_HOME not set"
```powershell
# Vérifier Java
java -version

# Définir JAVA_HOME (adapter le chemin)
$env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-17.0.x"
```

### Erreur: Compilation échoue
```powershell
# Nettoyer complètement
mvn clean

# Forcer le téléchargement des dépendances
mvn clean install -U -DskipTests
```

### VSCode: Erreurs rouges partout
1. **Recharger Maven:**
   - `Ctrl + Shift + P`
   - Taper: `Java: Clean Java Language Server Workspace`
   - Redémarrer VSCode

2. **Recharger le projet:**
   - Clic droit sur `pom.xml`
   - `Maven` → `Reload Project`

---

## 📊 CHECKLIST DE VALIDATION

- [ ] Java 17 installé (`java -version`)
- [ ] Maven installé (`mvn -version`)
- [ ] Compilation réussie (`mvn clean install`)
- [ ] Application démarre (`mvn spring-boot:run`)
- [ ] Login fonctionne (test 1)
- [ ] GET students fonctionne (test 2)
- [ ] POST student fonctionne (test 3)
- [ ] GET sessions fonctionne (test 4)
- [ ] POST attendance fonctionne (test 5)
- [ ] H2 Console accessible

---

## 🎯 PROCHAINES ÉTAPES

Une fois tous les tests validés:
1. ✅ Backend fonctionnel
2. ✅ Connecter le frontend Flutter
3. ✅ Tester l'intégration complète

---

## 📚 RESSOURCES

- **Documentation Spring Boot:** https://spring.io/projects/spring-boot
- **Maven Guide:** https://maven.apache.org/guides/
- **Java 17 Download:** https://adoptium.net/

---

**Besoin d'aide?** Consultez `COMPLETE_GUIDE.md` pour plus de détails.
