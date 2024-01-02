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


minetest.register_chatcommand("topluck", {
    description = "affiche le topluck",
    params = "<nom du joueur>",
    func = function(name, param)
        local player_filter = param:trim()
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

        

        



        -- Afficher les statistiques

        local playername = player_filter
        if playername == "" then
            playername = "tout le monde"
        end

         -- Créer une interface pour afficher les statistiques
         local formspec = "size[12,21]" ..
    "label[0.5,0.5;Statistiques de " .. playername .. "]" ..
    "label[0.5,1.5;-------------------------------------]" ..
    "label[0.5,2.5;Nombre total de blocs cassés : " .. total_stone_blocks_broken .. "]" ..
    "label[0.5,3.5;Nombre de stone cassés: " .. stone_blocks_broken .. "]" ..
    "label[0.5,4.5;Nombre de deepslate cassés: " .. deepslate_blocks_broken .. "]" ..
    "label[0.5,5.5;Nombre de granite cassés: " .. granite .. "]" ..
    "label[0.5,6.5;Nombre de andesite cassés: " .. andesite .. "]" ..
    "label[0.5,7.5;Nombre de tuff cassés: " .. tuff .. "]" ..
    "label[0.5,8.5;Nombre de diorite cassés: " .. diorite .. "]" ..
    "label[0.5,9.5;Nombre de gravel cassés: " .. gravel .. "]" ..
    "label[0.5,10.5;-------------------------------------]" ..
    "label[0.5,11.5;Nombre de diamond blocs cassés : " .. diamond_blocks_broken .. "]" ..
    "label[0.5,12.5;Nombre de iron blocs cassés : " .. iron_blocks_broken .. "]" ..
    "label[0.5,13.5;Nombre de gold blocs cassés : " .. gold_blocks_broken .. "]" ..
    "label[0.5,14.5;Nombre de lapis blocs cassés : " .. lapis_blocks_broken .. "]" ..
    "label[0.5,15.5;Nombre de coal blocs cassés : " .. cola_blocks_broken .. "]" ..
    "label[0.5,16.5;Nombre de redstone blocs cassés : " .. redstone_blocks_broken .. "]" ..
    "label[0.5,17.5;Nombre de copper blocs cassés : " .. copper .. "]" ..
    "label[0.5,18.5;Nombre total de ore cassés : " .. total_ore .. "]" ..
    "label[0.5,19.5;-------------------------------------]" ..
    "label[0.5,20.5;Chance de trouver un minerai : " .. roundedChance .. "%]"


minetest.show_formspec(playername, "modname:statistics_form", formspec)




     -- Ouvrir l'interface pour le joueur
     minetest.show_formspec(name, "modname:blockwatch_stats", formspec)




    end,
})





