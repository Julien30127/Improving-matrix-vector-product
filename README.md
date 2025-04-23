HEAD
# Lab 3: Exercise 2 - Matrix Product

## **Description**

Ce projet vise à évaluer et comparer les performances de deux implémentations d'un produit matriciel : une version naïve et une version optimisée à l'aide de techniques de **cache blocking**. Il utilise le framework **Kokkos** pour la gestion de la parallélisation et le calcul sur CPU. Les performances sont mesurées en termes de **GFLOPS**, de **cache misses**, et d'autres événements systèmes.

### **Objectifs du projet :**
1. **Optimisation de la multiplication matricielle** à l'aide du **cache blocking**.
2. **Analyse des performances** entre la version naïve et la version optimisée.
3. **Étude de l'évolutivité** avec des tests de **strong scaling** et **weak scaling**.
4. **Profilage des performances** avec **perf** pour récupérer des métriques comme les cache misses, les cycles, etc.

## **Prérequis**

Avant de commencer, assurez-vous d'avoir les éléments suivants installés sur votre machine :

- **Système d'exploitation** : Ubuntu, Debian, ou toute autre distribution Linux basée sur x86_64.
- **Kokkos** : Assurez-vous d'avoir la bibliothèque Kokkos correctement installée.
- **CMake** : Version 3.10 ou supérieure pour la construction du projet.
- **GCC** ou **Clang** : Un compilateur compatible avec C++17.
- **perf** : Outil de mesure des performances pour Linux.
- **Python** (pour générer des graphiques via des scripts de visualisation).

## **Installation**

### **1. Cloner le repository :**
Clonez le repository sur votre machine locale :

```bash
git clone https://github.com/Julien30127/Improving-matrix-vector-product.git
cd votre_repo

Faites ./run_naive pour lancer le projet
