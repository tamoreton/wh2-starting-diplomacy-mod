-- Simulate vassalisation through diplomacy menu
local function vassalise(master_faction_key, vassal_faction_keys)
    out("vassalise() called, master_faction_key: " .. master_faction_key .. ", vassal faction_keys: " .. tostring(vassal_faction_keys));

    local master_faction = cm:get_faction(master_faction_key);

    local regions_to_make_visible = {};

    for h = 1, #vassal_faction_keys do
        if not is_string(vassal_faction_keys[h]) then
		    script_error("ERROR: hamskii_script() called but item [" .. h .. "] in supplied list of faction keys is not a string; its value is [" .. tostring(vassal_faction_keys[h]) .. "]");
		    return false;
        end;

        local vassal_faction_key = vassal_faction_keys[h];
        local vassal_faction = cm:get_faction(vassal_faction_key);

        table.insert(regions_to_make_visible, vassal_faction:region_list());

        -- force war between master faction and any of vassal faction enemies so vassal/master rules are preserved
        local vassal_enemies = {};

        table.insert(vassal_enemies, vassal_faction:factions_at_war_with());

        local human_factions = cm:get_human_factions();
        local player_1 = cm:get_faction(human_factions[1]);
        local player_2 = nil;
        -- only get player 2 if one exists
        if cm:is_multiplayer() then
            player_2 = cm:get_faction(human_factions[2]);
        end;

        -- declare war on all enemies of master's vassals unless they are allied with a player faction
        for i = 1, #vassal_enemies do
            if vassal_enemies[i] and not vassal_enemies[i]:is_empty() then
                for j = 0, vassal_enemies[i]:num_items() - 1 do
                    local vassal_enemy = vassal_enemies[i]:item_at(j);
                    local vassal_enemy_name = vassal_enemy:name();

                    out("Forcing war between [" .. master_faction_key .. "] and [" .. vassal_enemy_name .. "]");
                    cm:force_declare_war(master_faction_key, vassal_enemy_name, false, false);

                    if not vassal_enemy:is_ally_vassal_or_client_state_of(player_1) and not (player_2 and vassal_enemy:is_ally_vassal_or_client_state_of(player_2)) then
                        -- go through all vassalised factions as one vassal might not have the same enemies as another - all factions should be at war with the same set after this
                        for k = 1, #vassal_faction_keys do
                            if vassal_faction_keys[k] ~= vassal_faction_key then
                                local other_vassal_faction_key = vassal_faction_keys[k];
                                local other_vassal_faction = cm:get_faction(other_vassal_faction_key);

                                if not other_vassal_faction:at_war_with(vassal_enemy) then
                                    out("Forcing war between [" .. other_vassal_faction_key .. "] and [" .. vassal_enemy_name .. "]");
                                    cm:force_declare_war(other_vassal_faction_key, vassal_enemy_name, false, false);
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;

        -- Force a faction to become the master of another faction
        out("force_make_vassal() called, master_faction_key: " .. master_faction_key .. ", vassal_faction_key: " .. vassal_faction_key);
        cm:force_make_vassal(master_faction_key, vassal_faction_key);
    end;

    for i = 1, #vassal_faction_keys do
        for j = 0, regions_to_make_visible:num_items() - 1 do
            cm:make_region_seen_in_shroud(vassal_faction_keys[i], regions_to_make_visible:item_at(j):name());
        end;
    end;
end;

local function create_alliance_network(faction_keys)
    out("create_alliance_network() called, faction_keys: " .. tostring(faction_keys));
    for _, faction_key_1 in ipairs(faction_keys) do
        for _, faction_key_2 in ipairs(faction_keys) do
            if faction_key_1 ~= faction_key_2 then
                out("Forcing alliance between [" .. faction_key_1 .. "] and [" .. faction_key_2 .. "]");
                cm:force_alliance(faction_key_1, faction_key_2);
            end;
        end;
    end;
end;

local function create_diplomatic_contact_network(faction_keys)
    out("create_diplomatic_contact_network() called, faction_keys: " .. tostring(faction_keys));
    for _, faction_key_1 in ipairs(faction_keys) do
        for _, faction_key_2 in ipairs(faction_keys) do
            if faction_key_1 ~= faction_key_2 then
                out("Making diplomacy available between [" .. faction_key_1 .. "] and [" .. faction_key_2 .. "]");
                cm:make_diplomacy_available(faction_key_1, faction_key_2);
            end;
        end;
    end;
end;

function hamskii_script()
    out("hamskii_script() called");
    if cm:is_new_game() then
        vassalise("wh_main_emp_empire", {
            "wh_main_emp_middenland",
            "wh_main_emp_averland",
            "wh_main_emp_talabecland",
            "wh_main_emp_ostland",
            "wh_main_emp_nordland",
            "wh_main_emp_hochland",
            "wh_main_emp_ostermark",
            "wh_main_emp_stirland",
            "wh_main_emp_wissenland"
        });
        cm:make_region_seen_in_shroud("wh_main_emp_empire", "wh_main_reikland_grunburg");
        cm:make_region_seen_in_shroud("wh_main_emp_empire", "wh_main_reikland_eilhart");
        cm:make_region_seen_in_shroud("wh_main_emp_empire", "wh_main_reikland_helmgart");
        cm:make_region_seen_in_shroud("wh_main_emp_empire", "wh_main_the_wasteland_marienburg");
        cm:make_region_seen_in_shroud("wh_main_emp_empire", "wh_main_the_wasteland_gorssel");
        cm:make_region_seen_in_shroud("wh_main_emp_empire", "wh_main_eastern_sylvania_castle_drakenhof");
        cm:make_region_seen_in_shroud("wh_main_emp_empire", "wh_main_eastern_sylvania_eschen");
        cm:make_region_seen_in_shroud("wh_main_emp_empire", "wh_main_eastern_sylvania_waldenhof");
        cm:make_region_seen_in_shroud("wh_main_emp_empire", "wh_main_western_sylvania_castle_templehof");
        cm:make_region_seen_in_shroud("wh_main_emp_empire", "wh_main_western_sylvania_fort_oberstyre");
        cm:make_region_seen_in_shroud("wh_main_emp_empire", "wh_main_western_sylvania_schwartzhafen");

        vassalise("wh_main_dwf_dwarfs", {
            "wh_main_dwf_barak_varr",
            "wh_main_dwf_karak_azul",
            "wh_main_dwf_karak_hirn",
            "wh_main_dwf_karak_izor",
            "wh_main_dwf_karak_kadrin",
            "wh_main_dwf_karak_norn",
            "wh_main_dwf_karak_ziflin",
            "wh_main_dwf_zhufbar",
            "wh2_main_dwf_greybeards_prospectors"
        });

        cm:make_diplomacy_available("wh_main_dwf_dwarfs", "wh_main_dwf_kraka_drak");
        cm:make_region_seen_in_shroud("wh_main_dwf_dwarfs", "wh_main_gianthome_mountains_khazid_bordkarag");
        cm:make_region_seen_in_shroud("wh_main_dwf_dwarfs", "wh_main_gianthome_mountains_kraka_drak");
        cm:make_region_seen_in_shroud("wh_main_dwf_dwarfs", "wh_main_gianthome_mountains_sjoktraken");
        cm:make_region_seen_in_shroud("wh_main_dwf_dwarfs", "wh_main_northern_worlds_edge_mountains_karak_ungor");
        cm:make_region_seen_in_shroud("wh_main_dwf_dwarfs", "wh_main_rib_peaks_mount_gunbad");
        cm:make_region_seen_in_shroud("wh_main_dwf_dwarfs", "wh_main_death_pass_karak_drazh");
        cm:make_region_seen_in_shroud("wh_main_dwf_dwarfs", "wh_main_western_badlands_ekrund");
        cm:make_region_seen_in_shroud("wh_main_dwf_dwarfs", "wh_main_eastern_badlands_karak_eight_peaks");
        cm:make_region_seen_in_shroud("wh_main_dwf_dwarfs", "wh_main_blightwater_karak_azgal");
        cm:make_region_seen_in_shroud("wh_main_dwf_dwarfs", "wh_main_southern_badlands_galbaraz");

        --[[
        cm:force_confederation("wh_main_vmp_schwartzhafen", "wh2_main_vmp_the_silver_host");
        cm:transfer_region_to_faction("wh_main_western_sylvania_schwartzhafen", "wh_main_vmp_vampire_counts");
        cm:force_confederation("wh_main_vmp_vampire_counts", "wh_main_vmp_rival_sylvanian_vamps");
        --cm:teleport_to(char_lookup_str(target_char), new_pos_x, new_pos_y, true);
        cm:force_declare_war("wh_main_vmp_schwartzhafen", "wh_main_vmp_vampire_counts", true, true);

        vassalise("wh_dlc05_wef_wood_elves", {
            "wh_dlc05_wef_argwylon",
            "wh_dlc05_wef_torgovann",
            "wh_dlc05_wef_wydrioth"
        });

        vassalise("wh_main_brt_bretonnia", {
            "wh_main_brt_bordeleaux",
            "wh_main_brt_carcassonne",
            "wh_main_brt_artois",
            "wh_main_brt_bastonne",
            "wh_main_brt_lyonesse",
            "wh_main_brt_parravon",
            "wh_main_vmp_mousillon",
            "wh2_main_brt_knights_of_origo",
            "wh2_main_brt_knights_of_the_flame",
            "wh2_main_brt_thegans_crusaders"
        });

        vassalise("wh_dlc08_nor_norsca", {
            "wh_dlc08_nor_helspire_tribe",
            "wh_dlc08_nor_vanaheimlings"
        });
        cm:force_confederation("wh_dlc08_nor_norsca","wh_main_nor_skaeling");
        vassalise("wh_dlc08_nor_wintertooth", {
            "wh_dlc08_nor_goromadny_tribe",
            "wh_dlc08_nor_naglfarlings"
        });
        cm:force_confederation("wh_dlc08_nor_wintertooth","wh_main_nor_varg");

        create_alliance_network({
            "wh2_main_hef_eataine",
            "wh2_main_hef_caledor",
            "wh2_main_hef_avelorn",
            "wh2_main_hef_ellyrion",
            "wh2_main_hef_saphery",
        });
        create_alliance_network({
            "wh2_main_hef_tiranoc",
            "wh2_main_hef_nagarythe",
            "wh2_main_hef_chrace",
            "wh2_main_hef_cothique",
            "wh2_main_hef_yvresse"
        });
        vassalise("wh2_main_hef_saphery", { "wh2_main_hef_order_of_loremasters" });

        vassalise("wh2_main_def_naggarond", {
            "wh2_main_def_cult_of_pleasure",
            "wh2_main_def_bleak_holds",
            "wh2_main_def_clar_karond",
            "wh2_main_def_cult_of_excess",
            "wh2_main_def_deadwood_sentinels",
            "wh2_main_def_ghrond",
            "wh2_main_def_har_ganeth",
            "wh2_main_def_karond_kar",
            "wh2_main_def_scourge_of_khaine",
            "wh2_main_def_ssildra_tor",
            "wh2_main_def_the_forgebound"
        });

        create_alliance_network({
            "wh2_main_lzd_hexoatl",
            "wh2_main_lzd_itza",
            "wh2_main_lzd_sentinels_of_xeti",
            "wh2_main_lzd_teotiqua",
            "wh2_main_lzd_tlaxtlan",
            "wh2_main_lzd_xlanhuapec"
        });
        vassalise("wh2_main_lzd_hexoatl", { "wh2_main_lzd_last_defenders" });

        create_diplomatic_contact_network({
            "wh2_main_skv_clan_mors",
            "wh2_dlc09_skv_clan_rictus",
            "wh2_main_skv_clan_gnaw",
            "wh2_main_skv_clan_mordkin",
            "wh2_main_skv_clan_skyre",
            "wh2_main_skv_clan_eshin",
            "wh2_main_skv_clan_moulder",
            "wh2_main_skv_clan_pestilens"
        });
        create_alliance_network({
            "wh2_main_skv_clan_skyre",
            "wh2_main_skv_clan_eshin",
            "wh2_main_skv_clan_moulder",
            "wh2_main_skv_clan_pestilens"
        });

        vassalise("wh2_dlc09_tmb_khemri",
        {
            "wh2_dlc09_tmb_lybaras",
            "wh2_dlc09_tmb_exiles_of_nehek",
            "wh2_dlc09_tmb_numas",
            "wh2_dlc09_tmb_dune_kingdoms",
            "wh2_dlc09_tmb_rakaph_dynasty",
            --"wh2_dlc09_tmb_followers_of_nagash"
        });
        --]]
    end;
    out("hamskii_script() complete");
end;