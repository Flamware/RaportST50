#!/bin/bash

# Fichier de sortie
OUTPUT="fusion_daily.txt"

# Vider le fichier de sortie s'il existe déjà
> "$OUTPUT"

# Liste ordonnée des dossiers (ordre chronologique)
MOIS=("février" "mars" "avril" "mai" "juin" "juillet")

echo "Début de la fusion des rapports quotidiens..."

# 1. Fusionner les mois dans l'ordre chronologique
for m in "${MOIS[@]}"; do
    if [ -d "$m" ]; then
        echo "Traitement du mois : $m"
        # Trouver les fichiers .typ, les trier par nom (ordre des jours)
        # On utilise 'sort' pour s'assurer du bon ordre (ex: 03.03 avant 04.03)
        find "$m" -maxdepth 1 -name "*.typ" | sort | while read -r fichier; do
            echo -e "\n=========================================" >> "$OUTPUT"
            echo " FICHIER : $fichier" >> "$OUTPUT"
            echo -e "=========================================\n" >> "$OUTPUT"

            # Ajouter le contenu du fichier
            cat "$fichier" >> "$OUTPUT"
            echo -e "\n" >> "$OUTPUT"
        done
    fi
done

# 2. Optionnel : Ajouter les fichiers à la racine s'ils t'intéressent
for f in mission.typ presentation-tests.typ; do
    if [ -f "$f" ]; then
        echo "Ajout du fichier racine : $f"
        echo -e "\n=========================================" >> "$OUTPUT"
        echo " FICHIER RACINE : $f" >> "$OUTPUT"
        echo -e "=========================================\n" >> "$OUTPUT"
        cat "$f" >> "$OUTPUT"
        echo -e "\n" >> "$OUTPUT"
    fi
done

echo "Fusion terminée ! Le fichier global est disponible ici : $(pwd)/$OUTPUT"
