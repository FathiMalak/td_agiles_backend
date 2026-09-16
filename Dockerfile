# --- Étape 1 : construire le .jar --
FROM maven:3.9-eclipse-temurin-21 AS build 
#démarre une image de base qui contient déjà Maven 3.9 et Java 21 (Temurin = distribution OpenJDK).

WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
#Ce que ça fait : télécharge toutes les dépendances listées dans le pom.xml et les stocke dans le cache local de Maven.
#À quoi ça sert : prépare le terrain pour la compilation, sans avoir encore besoin du code source. 
COPY src ./src

RUN mvn clean package -DskipTests
#Ce que ça fait : lance la compilation Maven → génère le fichier .jar dans /app/target/.
#clean : supprime d'anciens fichiers compilés s'il y en a
#package : compile et empaquette en .jar
#-DskipTests : n'exécute pas les tests unitaires pendant le build (pour aller plus vite ; les tests sont censés avoir déjà tourné avant, en CI par exemple)

# --- Étape 2 : image finale, légère --
FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]

#NOTES  A retenir

# --- Étape 1 : Build (fabriquer le .jar) ---
# À quoi elle sert : compiler le code Java (Spring Boot) pour produire un fichier .jar exécutable.
# Elle a besoin d'outils lourds : Maven, le JDK complet (compilateur),
# toutes les dépendances téléchargées, le code source.
# Une fois le .jar généré, tous ces outils deviennent inutiles.
# C'est une étape temporaire — une sorte d'atelier de fabrication qu'on va jeter après usage.

# --- Étape 2 : Final (faire tourner l'application) ---
# À quoi elle sert : exécuter le .jar déjà compilé, c'est-à-dire faire tourner l'application réellement.
# Elle n'a besoin que d'un JRE (l'environnement minimal pour lancer du Java) —
# pas de Maven, pas du code source, pas des outils de compilation.
# Elle récupère uniquement le .jar fabriqué à l'étape 1,
# et c'est cette image-là (légère) qui sera publiée et déployée.

# --- En une phrase ---
# Étape 1 = usine de fabrication (grosse, avec plein d'outils, jetée après usage)
# Étape 2 = produit fini livré (petit, juste ce qu'il faut pour fonctionner)
# On sépare les deux pour éviter que l'image finale soit inutilement lourde
# et encombrée d'outils de compilation dont elle n'a plus besoin une fois le .jar créé.

#EXTRA INFO MORE

#Pourquoi 
#COPY pom.xml puis 
#go-offline avant de copier 
#chaque instruction. Tant que le 
#src ? Docker met en cache
#pom.xml ne change pas, le téléchargement des dépendances est
#réutilisé du cache : les builds suivants sont bien plus rapides.