# Calcul des distances a vol d'oiseau entre 2 coordonnees GPS
# X. Gandibleux - Octobre 2019

using Printf
using DelimitedFiles

# Donnees dans un fichier au format CSV séparé par des virgules avec :
# - ligne 1 : header
# - colonne 1 : nom du lieu
# - colonne 2 : position x du lieu
# - colonne 3 : position y du lieu
# - colonne 4 : latitude du lieu
# - colonne 5 : longitude du lieu
# donnees extraites de : https://data.education.gouv.fr
m = readdlm("GPSlyceesNantes.csv", ',')

# Fonction de conversion degre vers radian
function deg_rad(v)
    return pi/180*v
end

# Calcul du distancier
lieu = String[]
for i in 2:size(m,1)
    push!(lieu, m[i,1])
end

dist = zeros(size(m,1)-1, size(m,1)-1)
for i in 2:size(m,1)-1
    for j in i+1:size(m,1)

        LatitudeA  = m[i,4]
        LongitudeA = m[i,5]
        LatitudeB  = m[j,4]
        LongitudeB = m[j,5]

        # formule des sinus : http://villemin.gerard.free.fr/aGeograp/Distance.htm
        # https://www.coordonnees-gps.fr/conversion-coordonnees-gps

        d = acos(
             sin(deg_rad(LatitudeA)) * sin(deg_rad(LatitudeB))
             +
             cos(deg_rad(LatitudeA)) * cos(deg_rad(LatitudeB)) * cos(deg_rad(LongitudeB) - deg_rad(LongitudeA))
            ) * 6371

        @printf("%2d - %2d = %6.3f km | %s <-> %s \n",i-1, j-1, d, m[i,1], m[j,1])

        dist[i-1,j-1] = d
        dist[j-1,i-1] = d
    end
end

println("distancier symétrique crée : ", length(lieu), " lieux")
