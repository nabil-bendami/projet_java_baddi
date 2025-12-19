# 🧪 GUIDE DE TEST - BATCH F1

## Étape 1: Installation des Dépendances

```bash
cd frontend_flutter
flutter pub get
```

**Résultat attendu:**
```
Running "flutter pub get" in frontend_flutter...
Resolving dependencies...
+ dio 5.4.0
+ flutter_localizations 0.0.0 from sdk flutter
+ flutter_secure_storage 9.0.0
...
Got dependencies!
```

---

## Étape 2: Vérification de la Compilation

```bash
flutter analyze
```

**Résultat attendu:**
- Aucune erreur critique
- Possibles warnings mineurs (acceptable)

---

## Étape 3: Lancer l'Application

```bash
flutter run
```

**Ou spécifier un device:**
```bash
flutter devices
flutter run -d <device_id>
```

---

## 🔍 TESTS CRITIQUES À EFFECTUER

### TEST 1: LocaleDataException Corrigée ✅

**Procédure:**
1. Lancer l'app
2. Observer les logs au démarrage
3. Naviguer vers n'importe quel écran avec des dates

**✅ SUCCÈS si:**
- Aucune erreur "LocaleDataException" dans les logs
- L'app démarre normalement
- Les dates s'affichent (si présentes)

**❌ ÉCHEC si:**
- Erreur "Locale data has not been initialized"
- Crash au démarrage
- Dates non formatées

**Rapport:**
```
[ ] ✅ Pas d'erreur LocaleDataException
[ ] ✅ App démarre sans crash
[ ] ✅ Dates affichées correctement (si applicable)
```

---

### TEST 2: Overflow Dashboard Corrigé ✅

**Procédure:**
1. Login avec: `admin@presence.com` / `admin123`
2. Observer le dashboard Admin
3. Vérifier les cards de statistiques
4. Répéter avec Prof et Student

**✅ SUCCÈS si:**
- Aucun message "BOTTOM OVERFLOWED BY X PIXELS"
- Cards s'affichent correctement
- Texte ne déborde pas

**❌ ÉCHEC si:**
- Messages d'overflow en jaune/noir
- Cards mal affichées
- Texte coupé

**Rapport:**
```
[ ] ✅ Admin Dashboard - Pas d'overflow
[ ] ✅ Prof Dashboard - Pas d'overflow  
[ ] ✅ Student Dashboard - Pas d'overflow
[ ] ✅ Cards bien dimensionnées
```

---

### TEST 3: Navigation de Base ✅

**Procédure:**
1. Splash screen → Login (2 secondes)
2. Login → Dashboard (selon rôle)
3. Ouvrir le drawer menu
4. Naviguer vers 2-3 écrans

**✅ SUCCÈS si:**
- Transitions fluides
- Pas de crash
- Drawer s'ouvre correctement

**❌ ÉCHEC si:**
- Crash lors de navigation
- Écrans blancs
- Erreurs de routing

**Rapport:**
```
[ ] ✅ Splash → Login fonctionne
[ ] ✅ Login → Dashboard fonctionne
[ ] ✅ Drawer menu s'ouvre
[ ] ✅ Navigation entre écrans OK
```

---

## 📊 RAPPORT DE TEST

### Résumé des Tests

**TEST 1 - LocaleDataException:**
- [ ] ✅ PASSÉ
- [ ] ❌ ÉCHOUÉ (détails: _________________)

**TEST 2 - Overflow Dashboard:**
- [ ] ✅ PASSÉ
- [ ] ❌ ÉCHOUÉ (détails: _________________)

**TEST 3 - Navigation:**
- [ ] ✅ PASSÉ
- [ ] ❌ ÉCHOUÉ (détails: _________________)

### Logs d'Erreurs (si applicable)

```
Copiez ici les erreurs rencontrées:


```

### Screenshots (optionnel)

Si overflow ou problème visuel, prenez des screenshots.

---

## 🚀 APRÈS LES TESTS

### Si TOUS les tests PASSENT ✅

**Répondez:**
```
✅ BATCH F1 validé!
- LocaleDataException: OK
- Overflow: OK
- Navigation: OK

Prêt pour BATCH F2 (ApiClient + Repositories)
```

### Si des tests ÉCHOUENT ❌

**Répondez avec les détails:**
```
❌ Problèmes détectés:

TEST X échoué:
- Erreur: [copier l'erreur exacte]
- Logs: [copier les logs pertinents]
- Screenshot: [si applicable]

Besoin de corrections avant BATCH F2
```

---

## 🔧 Commandes Utiles

```bash
# Hot reload (pendant que l'app tourne)
r

# Hot restart (nécessaire après changements de locale)
R

# Nettoyer et reconstruire
flutter clean
flutter pub get
flutter run

# Voir tous les logs
flutter logs

# Tester sur Chrome (si disponible)
flutter run -d chrome
```

---

## ⏱️ Temps Estimé

- Installation: 2-3 minutes
- Tests critiques: 5-10 minutes
- **Total: ~15 minutes maximum**

---

## 📞 Support

Si vous rencontrez des problèmes:
1. Copiez l'erreur exacte
2. Copiez les logs pertinents
3. Indiquez à quelle étape ça bloque
4. Je corrigerai immédiatement

**Bonne chance! 🚀**
