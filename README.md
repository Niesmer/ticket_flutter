# ticket_flutter

Application mobile Flutter pour la gestion et l’achat de billets d’événements, connectée à Supabase.

## Objectif du projet

`ticket_flutter` est une application Flutter qui permet de :
- **consulter des événements** (nom, dates/heures, lieu, prix, nombre de billets, période d’ouverture/fermeture de la billetterie),
- **gérer des profils utilisateurs** (pseudo, nom/prénom, rôle, email, favoris/likes),
- **réserver/acheter des places** pour un événement (ex. numéro de siège) via des commandes.

Le backend (données + accès) est fourni par **Supabase** via des tables (ex. `Profiles`, `Events`, `Command`).

## Fonctionnalités (selon le modèle de données)

- **Événements**
  - Liste et détails d’un événement (prix, dates/heures, localisation, stock de billets, fenêtre de vente).
- **Comptes / profils**
  - Informations utilisateur (pseudo, identité, rôle, email).
  - Gestion d’éléments “likés” (ex. `likedIds`).
- **Billetterie**
  - Création de commandes/réservations liées à un utilisateur et un événement (ex. `seat_nbr`).

## Prérequis

- [Flutter](https://flutter.dev/docs/get-started/install)
- Un IDE (ex. [Visual Studio Code](https://code.visualstudio.com/) ou [Android Studio](https://developer.android.com/studio))

## Installation

1. Installer les dépendances :
   ```sh
   flutter pub get
2. Lancer l’application (avec un appareil ou un émulateur) :
   ```sh
    flutter run

3. Configuration Supabase

   L’application s’appuie sur Supabase pour stocker et récupérer les données.
   
   Créez un projet sur Supabase.
   
   Dans Table Editor, créez les tables nécessaires, par exemple :
      - **Profiles** : id, pseudo, nom, prenom, role, likedIds, email
      - **Command** : id, id_event, id_user, seat_nbr
      - **Events** : id, price, name, event_date_start, event_date_end, event_time_start, event_time_end, location, tickets_nbr, opening_date_ticket, opening_time_ticket, closing_date_ticket, etc.
   
   Pour plus d'information sur les attendus Supabase du projet regarder le fichier [supabase.dart](https://github.com/Niesmer/ticket_flutter/blob/main/lib/supabase.dart)
   
   Récupérez l’URL du projet et la Anon Key dans les paramètres Supabase.
   
   Ajoutez ces valeurs dans la configuration de l’app Flutter (fichier/variables de config utilisés par le projet).
   
   Remarque : le schéma exact des colonnes et les règles (RLS/policies) doivent être alignés avec la logique attendue par l’application.
   
   Documentation : [Supabase Docs](https://supabase.com/docs)
