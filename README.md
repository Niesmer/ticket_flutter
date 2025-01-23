# ticket_flutter

Un nouveau projet Flutter.

## Pour commencer

Ce projet est un point de départ pour une application Flutter.

### Prérequis

- [Flutter](https://flutter.dev/docs/get-started/install) installé sur votre machine.
- Un éditeur de code comme [Visual Studio Code](https://code.visualstudio.com/) ou [Android Studio](https://developer.android.com/studio).

### Création de l'application Flutter

1. Ouvrez votre terminal ou invite de commande.
2. Exécutez la commande suivante pour créer un nouveau projet Flutter :
   ```sh
   flutter create ticket_flutter
   ```
3. Accédez au répertoire du projet :
   ```sh
   cd ticket_flutter
   ```
4. Ouvrez le projet dans votre éditeur de code préféré.

### Installation des dépendances

1. À la racine du projet, exécutez la commande suivante pour installer toutes les dépendances :
   ```sh
   flutter pub get
   ```

### Exécution de l'application

1. Assurez-vous d'avoir un appareil connecté ou un émulateur en cours d'exécution.
2. Exécutez la commande suivante pour démarrer l'application :
   ```sh
   flutter run
   ```

### Configuration de Supabase

Pour utiliser ce projet, vous devez configurer une table Supabase. Suivez ces étapes :

1. Allez sur [Supabase](https://supabase.io/) et inscrivez-vous pour un compte.
2. Créez un nouveau projet dans le tableau de bord Supabase.
3. Accédez à l'éditeur de tables ("Table Editor") et créez les tables nécessaires avec les colonnes appropriées pour votre application :
   - **Profiles** : id, pseudo, nom, prenom, role, likedIds, email
   - **Command** : id, id_event, id_user, seat_nbr
   - **Events** : id, price, name, event_date_start, event_date_end, event_time_start, event_time_end, location, tickets_nbr, opening_date_ticket, opening_time_ticket, closing_date_ticket, closing_time_ticket, state, created_by
4. Copiez l'URL de l'API et la clé anonyme depuis les paramètres du projet Supabase.
5. Ajoutez ces valeurs au fichier de configuration de votre projet Flutter.

Pour des instructions plus détaillées, consultez la [documentation Supabase](https://supabase.io/docs).

## Ressources supplémentaires

Quelques ressources pour vous aider à démarrer si c'est votre premier projet Flutter :

- [Lab: Écrivez votre première application Flutter](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Exemples utiles Flutter](https://docs.flutter.dev/cookbook)

Pour obtenir de l'aide sur le démarrage avec le développement Flutter, consultez la
[documentation en ligne](https://docs.flutter.dev/), qui propose des tutoriels,
des exemples, des conseils sur le développement mobile et une référence complète de l'API.
