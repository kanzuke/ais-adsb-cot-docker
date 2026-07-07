## Principes

Une antenne DIY peut être simplement réalisée à partir d’un Raspberry PI et de récepteur RTL-SDR. La distribution ADS-B Feeder Image sera employée comme OS de base, puis pour le traitement et l’envoi des données via protocole CoT, des packages python (dockerisés pour l’occasion pour faciliter le déploiement) seront utilisés.

## Prérequis

*   Raspberry Pi 3/4/5 – 1GB Ram minimum
*   Carte micro-SD 16Go
*    [Récepteur(s) RTL-SDR](https://www.nooelec.com/store/sdr/sdr-bundles/stratux-bundle-nano-2-plus.html)
*    Antenne(s) adaptées ADS-B / AIS

## Installation d’ADS-B Image Feeder

Utiliser Raspberry Pi Imager pour installer [ADS-B Image Feeder](https://adsb.im/home) sur la carte micro-SD

Document d’installation: [https://adsb.im/howto](https://adsb.im/howto)

## Configuration d’ADS-B Feeder

Se rendre sur l’interface web [http://@ip](http://ip)

Affecter les récepteurs RTL-SDR aux périmètres recherchés.

A ce stade, l’antenne permet de capter les traces ADS-B et AIS environnantes.

Dans **Setup/Expert**, il est également possible de faire apparaître les points AIS sur la carte ADS-B.

## (Optionnel) Installation et configuration du client Wireguard

Pour lier l’antenne à DSNode et transférer les données ADS-B/AIS via CoT, il est nécessaire de mettre en place un tunnel Wireguard.

Le fichier de configuration est à générer et récupérer directement sur le DSNode de rattachement.

Copier le contenu du fichier de configuration dans **/etc/wireguard/wg0.conf**

Monter l’interface :

    wg-quick up wg0

Activation de l’interface au démarrage du système :

    sudo systemctl enable wg-quick@wg0.service

## Transformation et transmission en CoT

A ce stade, l’antenne ne fait que recevoir les pistes AIS/ADS-B, sans les rediffuser.

Pour pouvoir les transmettre à DSNode ou à DeltaSuite, il faut les rediffuser en CoT (particularité : lorsque DeltaSuite est installé avec l’option AEM, il peut être traité directement les paquets NMEA AIS).

Des paquets python existent permettent la conversion en CoT des données ADS-B et AIS. Cependant, leur installation nécessite des prérequis Python, parfois disponible directement dans les dépôts Debian, parfois nécessitent une installation via pip (l’outil de gestion des librairies sous Python).

Leur installation peut donc être difficile. Pour faciliter cette installation/configuration, des images docker prêtes à l’emploi ont été créées.

Enfin, un script python « cot-multi-targets » a été créé pour permettre d’envoyer la trame CoT finale à plusieurs destinations en simultanée. Ce script corrige également certaines valeurs non reconnues par DSNode (mais pas par DeltaSuite) et qui étaient alors purement et simplement rejetées par ce dernier.

L’ensemble de ces éléments sont disponibles sur le dépôt github ci-après, ainsi que les instructions d’installation :

[https://github.com/kanzuke/ais-adsb-cot-docker](https://github.com/kanzuke/ais-adsb-cot-docker)

Précision : pour l’AIS, il est nécessaire de configurer dans ADS-B.im le docker shipfeeder pour relayer les données AIS au container AISCOT.

Cette configuration se fait dans Setup/Expert, rubrique AIS et en ajoutant la configuration :

L’ip à renseigner est l’ip à laquelle depuis laquelle sera accessible **aiscot.**   
Si l’ip du raspberry n’est pas maîtrisée (dhcp), il est préférable de mettre en adresse ip l’adresse de passerelle du réseau docker sur lequel se situe shipfeeder (cette ip correspondant donc au raspberry). / ! \\

### Transformation CoT

Sur la chaine de transmission complète, les données CoT passent par **cotproxy** et **cotproxyweb**.

Ces derniers permettent entre autres, de customiser les données CoT à la volée, en changeant par exemple le code SIDC de l’objet, et ainsi manipuler son affichage sur les différents systèmes à l’arrivée (DeltaSuite).

L’interface d’administration est accessible à l’url : **http://@ip:10415/admin**

Le login/mot de passe est défini dans le compose.yml global (par défaut admin/admin).

En revanche, il est également nécessaire de préciser les adresses ip par lesquelles cette interface web devra être accessible (paramètre **DJANGO\_ALLOWED\_HOSTS** dans le fichier compose.yml)

### Transmission COT

La retransmission CoT se fait via le container **cotmultitargets**. Ce dernier s'occupe:

*   de corriger certaines valeurs CoT qui sont rejetées par DSNode
*   procéder aux retransmissions TCP ou UDP aux différentes destinations configurées.

La configuration des destinations est à réaliser dans le fichier **config.json** dudit container.

## Boîtier 3D

Le boitier 3D suivant a été imprimé pour intégrer le Rapsberry PI et les récépteurs RTL SDR.

[https://www.thingiverse.com/thing:2953741](https://www.thingiverse.com/thing:2953741)

## CONOPS

```text
ultrafeeder (ADS-B JSON)         AIS Source
        ↓                            ↓
     adsbcot  ───────┬─────────── aiscot
                     ↓
                 (UDP 8087)
                     ↓
                 cotproxy ---→ cotproxyweb (monitoring UI)
                     ↓
                  TCP 9090
                     ↓
               cotmultitargets
                     ↓
     multiple destinations (ATAK, multicast, etc.)

```