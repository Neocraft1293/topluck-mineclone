-- Chemin vers le fichier JSON pour les événements
local events_json_file_path = minetest.get_worldpath() .. "/blockwatch_data.json"

-- Fonction pour charger les données depuis le fichier JSON
local function load_blockwatch_data()
    local file = io.open(events_json_file_path, "r")

    -- Vérifier si le fichier existe
    if not file then
        minetest.log("action", "[Modname] Le fichier JSON n'existe pas.")
        return {}
    end

    local data = minetest.deserialize(file:read("*a"))
    io.close(file)
    return data or {}
end


minetest.register_chatcommand("checkuserluck", {
    description = "affiche le topluck",
    params = "<nom du joueur>",
    func = function(name, param)
        local player_filter = param:trim()

local result = calculateBlockStats(player_filter)
local total_blocks_broken = result.total_blocks_broken
local total_ore = result.total_ore
local total_stone_blocks_broken = result.total_stone_blocks_broken
local chance = result.chance
local playername = player_filter
        if playername == "" then
            playername = "tout le monde"
        end
-- Créer une interface pour afficher les statistiques
local formspec = "size[12,6]" ..
"label[0.5,0.5;Statistiques de " .. playername .. "]" ..
"label[0.5,1.5;Total des blocs cassés: " .. total_blocks_broken .. "]" ..
"label[0.5,2.5;Total des minerais: " .. total_ore .. "]" ..
"label[0.5,3.5;Total des blocs de pierre cassés: " .. total_stone_blocks_broken .. "]" ..
"label[0.5,4.5;Chance pondérée: " .. chance .. "%]" ..
"button_exit[0.5,5;2,1;exit;Fermer]"

     -- Ouvrir l'interface pour le joueur
        minetest.show_formspec(name, "blockwatch:stats", formspec)









    end,
})



-- Définir la fonction avec le paramètre player_filter
function calculateBlockStats(player_filter)
     -- Charger les données depuis le fichier à chaque exécution de la commande
     local all_events = load_blockwatch_data()

     -- Initialiser les compteurs
     local first_event_blocks = 0
     local diamond_blocks_broken = 0
     local iron_blocks_broken = 0 
     local gold_blocks_broken = 0
     local lapis_blocks_broken = 0
     local cola_blocks_broken = 0
     local stone_blocks_broken = 0
     local deepslate_blocks_broken = 0
     local granite = 0
     local andesite = 0
     local gravel = 0
     local tuff = 0
     local diorite = 0
     local copper = 0
     local redstone_blocks_broken = 0
     local total_ore = 0
     local chance = 0
     local total_blocks_broken = 0
     local total_stone_blocks_broken = 0



     -- Parcourir toutes les coordonnées
     for coord, event_list in pairs(all_events) do
         -- Parcourir les événements de la coordonnée actuelle
         for order, event in ipairs(event_list) do
             if order == 1 and event.event_type == "break"  then
                 if player_filter == "" or (player_filter ~= "" and event.entity == player_filter) then
                     total_blocks_broken = total_blocks_broken + 1
                     if event.node_name == "mcl_core:stone" then
                         stone_blocks_broken = stone_blocks_broken + 1
                     end
                     if event.node_name == "mcl_core:stone_with_iron" then
                         iron_blocks_broken = iron_blocks_broken + 1
                     end
                     if event.node_name == "mcl_deepslate:deepslate_with_iron" then
                         iron_blocks_broken = iron_blocks_broken + 1
                     end
                     if event.node_name == "mcl_core:stone_with_diamond" then
                         diamond_blocks_broken = diamond_blocks_broken + 1
                     end
                     if event.node_name == "mcl_deepslate:deepslate_with_diamond" then
                         diamond_blocks_broken = diamond_blocks_broken + 1
                     end
                     if event.node_name == "mcl_core:stone_with_gold" then
                         gold_blocks_broken = gold_blocks_broken + 1
                     end
                     if event.node_name == "mcl_deepslate:deepslate_with_gold" then
                         gold_blocks_broken = gold_blocks_broken + 1
                     end
                     if event.node_name == "mcl_core:stone_with_lapis" then
                         lapis_blocks_broken = lapis_blocks_broken + 1
                     end
                     if event.node_name == "mcl_deepslate:deepslate_with_lapis" then
                         lapis_blocks_broken = lapis_blocks_broken + 1
                     end
                     if event.node_name == "mcl_core:stone_with_coal" then
                         cola_blocks_broken = cola_blocks_broken + 1
                     end
                     if event.node_name == "mcl_deepslate:deepslate_with_coal" then
                         cola_blocks_broken = cola_blocks_broken + 1
                     end
                     if event.node_name == "mcl_core:stone_with_redstone_lit" then
                         redstone_blocks_broken = redstone_blocks_broken + 1
                     end
                     if event.node_name == "mcl_deepslate:deepslate_with_copper" then
                         copper = copper + 1
                     end
                     if event.node_name == "mcl_core:stone_with_copper" then
                         copper = copper + 1
                     end
                     if event.node_name == "mcl_deepslate:deepslate_with_redstone_lit" then
                         redstone_blocks_broken = redstone_blocks_broken + 1
                     end
                     if event.node_name == "mcl_deepslate:deepslate" then
                         deepslate_blocks_broken = deepslate_blocks_broken + 1
                     end
                     if event.node_name == "mcl_core:granite" then
                         granite = granite + 1
                     end
                     if event.node_name == "mcl_core:andesite" then
                         andesite = andesite + 1
                     end
                     if event.node_name == "mcl_deepslate:tuff" then
                         tuff = tuff + 1
                     end
                     if event.node_name == "mcl_core:diorite" then
                         diorite = diorite + 1
                     end
                     if event.node_name == "mcl_core:gravel" then
                         gravel = gravel + 1
                     end

                     first_event_blocks = first_event_blocks + 1
                 end
             end
         end
     end

     -- Coefficients pour chaque type de minerai
local diamond_coefficient = 5
local iron_coefficient = 3
local gold_coefficient = 2
local cola_coefficient = 1
local redstone_coefficient = 1
local copper_coefficient = 1
local lapis_coefficient = 1

-- Calcul du total pondéré des minerais
local total_ore = diamond_blocks_broken * diamond_coefficient +
               iron_blocks_broken * iron_coefficient +
               gold_blocks_broken * gold_coefficient +
               cola_blocks_broken * cola_coefficient +
               redstone_blocks_broken * redstone_coefficient +
               copper * copper_coefficient +
               lapis_blocks_broken * lapis_coefficient

-- Calcul du total des blocs cassés
local total_stone_blocks_broken = total_ore + stone_blocks_broken + deepslate_blocks_broken + granite +
                                andesite + tuff + diorite + gravel

-- Calcul de la chance pondérée
local chance = 0  -- initialisation par défaut

if total_stone_blocks_broken ~= 0 then
 chance = total_ore / total_stone_blocks_broken * 100
end

local roundedChance = math.floor(chance * 10 + 0.5) / 10

return {
    total_blocks_broken = total_blocks_broken,
    total_ore = total_ore,
    total_stone_blocks_broken = total_stone_blocks_broken,
    chance = roundedChance
}
end


















-- Fonction pour extraire les noms des joueurs à partir du fichier JSON avec pourcentage
local function get_player_names_from_json_with_percentage(player_filter)
    local file = io.open(events_json_file_path, "r")

    -- Vérifier si le fichier existe
    if not file then
        minetest.log("action", "[Modname] Le fichier JSON n'existe pas.")
        return {}
    end

    local data = minetest.deserialize(file:read("*a"))
    io.close(file)

    local player_data = {}
    local added_players = {}  -- Table pour vérifier les doublons

    for coord, event_list in pairs(data) do
        for _, event in ipairs(event_list) do
            if event.entity and event.entity ~= "Unknown" and not added_players[event.entity] then
                -- Ajouter la condition pour le filtre du joueur
                if player_filter == "" or (player_filter ~= "" and event.entity == player_filter) then
                    local result = calculateBlockStats(event.entity)
                    table.insert(player_data, {name = event.entity, chance = result.chance})
                    added_players[event.entity] = true  -- Marquer le pseudo comme ajouté
                end
            end
        end
    end

    -- Trier la liste en fonction du pourcentage (de manière décroissante)
    table.sort(player_data, function(a, b)
        return a.chance > b.chance
    end)

    return player_data
end

-- Fonction pour calculer les statistiques des blocs cassés
local function calculateBlockStats(player_name)
    -- ... (Votre logique de calcul de statistiques ici)
    -- Cela pourrait être similaire à votre logique existante

    -- Exemple: Calculer un pourcentage fictif
    local percentage = math.random(1, 100)
    
    -- Retourner les statistiques calculées, y compris le pourcentage
    return {
        chance = percentage,
        -- Ajoutez d'autres statistiques au besoin
    }
end

-- Commande pour lister les joueurs avec pourcentage depuis le fichier JSON
minetest.register_chatcommand("topluck", {
    description = "Affiche la liste des joueurs dans le fichier JSON avec pourcentage",
    func = function(name, param)
        -- Récupérer la liste des noms de joueurs avec pourcentage depuis le fichier JSON
        local player_data = get_player_names_from_json_with_percentage(param)

        -- Créer une liste de noms de joueurs avec pourcentage
        local player_list = ""
        for _, player_info in ipairs(player_data) do
            player_list = player_list .. player_info.name .. ": " .. player_info.chance .. "%\n"
        end

        -- Créer une interface pour afficher la liste des joueurs avec pourcentage
        local formspec = "size[12,6]" ..
            "label[1,0.5;Liste des joueurs dans le fichier JSON avec pourcentage:]" ..
            "textarea[1,1.5;6,4.5;;" .. minetest.formspec_escape(player_list) .. ";]"

        -- Afficher l'interface au joueur qui a exécuté la commande
        minetest.show_formspec(name, "modname:player_list_with_percentage_form", formspec)
    end,
})
