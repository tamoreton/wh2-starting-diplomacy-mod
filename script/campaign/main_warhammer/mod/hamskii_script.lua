-- Simulate vassalisation through diplomacy menu
local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true;
        end;
    end;

    return false;
end;

local function establish_diplomatic_contact_and_reveal_regions(playerable_faction_key, npc_faction_key)
    out("Making diplomacy available between [" .. playerable_faction_key .. "] and [" .. npc_faction_key .. "]");
    cm:make_diplomacy_available(playerable_faction_key, npc_faction_key);

    local npc_faction = cm:get_faction(npc_faction_key);
    local npc_faction_regions = npc_faction:region_list();

    for i = 0, npc_faction_regions:num_items() - 1 do
        cm:make_region_seen_in_shroud(playerable_faction_key, npc_faction_regions:item_at(i):name());
    end;
end;

local function preserve_vassal_master_rules(master_faction_key, vassal_faction_keys)
    out("preserve_vassal_master_rules() called, master_faction_key: " .. master_faction_key .. ", vassal faction_keys: " .. tostring(vassal_faction_keys));

    local master_faction = cm:get_faction(master_faction_key);

    local human_factions = cm:get_human_factions();
    local player_1 = cm:get_faction(human_factions[1]);
    local player_2 = nil;
    -- only get player 2 if one exists
    if cm:is_multiplayer() then
        player_2 = cm:get_faction(human_factions[2]);
    end;

    for h = 1, #vassal_faction_keys do
        if not is_string(vassal_faction_keys[h]) then
		    script_error("ERROR: hamskii_script() called but item [" .. h .. "] in supplied list of faction keys is not a string; its value is [" .. tostring(vassal_faction_keys[h]) .. "]");
		    return false;
        end;

        local vassal_faction_key = vassal_faction_keys[h];
        local vassal_faction = cm:get_faction(vassal_faction_key);

        out("Making diplomacy available between [" .. master_faction_key .. "] and [" .. vassal_faction_key .. "]");
        cm:make_diplomacy_available(master_faction_key, vassal_faction_key);

        if master_faction:at_war_with(vassal_faction) then
            out("Forcing peace between [" .. master_faction_key .. "] and [" .. vassal_faction_key .. "]");
            cm:force_make_peace(master_faction_key, vassal_faction_key);
        end;

        for i = 1, #vassal_faction_keys do
            local other_vassal_faction_key = vassal_faction_keys[i];
            local other_vassal_faction = cm:get_faction(other_vassal_faction_key);

            out("Making diplomacy available between [" .. vassal_faction_key .. "] and [" .. other_vassal_faction_key .. "]");
            cm:make_diplomacy_available(vassal_faction_key, other_vassal_faction_key);
             -- Crashes revealing wh2_main_def_har_ganeth's regions to wh2_main_def_ghrond for some reason
            establish_diplomatic_contact_and_reveal_regions(vassal_faction_key, other_vassal_faction_key);

            if vassal_faction:at_war_with(other_vassal_faction) then
                out("Forcing peace between [" .. vassal_faction_key .. "] and [" .. other_vassal_faction .. "]");
                cm:force_make_peace(vassal_faction_key, other_vassal_faction);
            end;
        end;

        if vassal_faction ~= player_1 or vassal_faction ~= player_2 then
            -- force war between master faction and any of vassal faction enemies so vassal/master rules are preserved
            local vassal_enemies = {};

            table.insert(vassal_enemies, vassal_faction:factions_at_war_with());

            -- declare war on all enemies of master's vassals unless they are allied with a player faction
            for i = 1, #vassal_enemies do
                if vassal_enemies[i] and not vassal_enemies[i]:is_empty() then
                    for j = 0, vassal_enemies[i]:num_items() - 1 do
                        local vassal_enemy = vassal_enemies[i]:item_at(j);
                        local vassal_enemy_name = vassal_enemy:name();

                        -- Need to figure out why Bretonnia goes to war with Karak Ziflin but not other Dwarf factions
                        -- Also, Karak Norn with Wood Elves
                        out("vassal_faction_key: " .. vassal_faction_key);
                        out("vassal_enemy_name: " .. vassal_enemy_name);

                        --[[ May be redundant and causing bugs...actually maybe not but let's keep it commented out anyways
                        if has_value(vassal_faction_keys, vassal_enemy_name) then
                            out("Forcing peace between [" .. vassal_faction_key .. "] and [" .. vassal_enemy_name .. "]");
                            cm:force_make_peace(vassal_faction_key, vassal_enemy_name);
                        end;
                        --]]

                        if not vassal_enemy:is_ally_vassal_or_client_state_of(player_1) and not (player_2 and vassal_enemy:is_ally_vassal_or_client_state_of(player_2)) then
                            if not has_value(vassal_faction_keys, vassal_enemy_name) and master_faction_key ~= vassal_enemy_name then
                                out("Forcing war between [" .. master_faction_key .. "] and [" .. vassal_enemy_name .. "]");
                                cm:force_declare_war(master_faction_key, vassal_enemy_name, true, true);
                            end;

                            -- go through all vassalised factions as one vassal might not have the same enemies as another
                            -- all factions should be at war with the same set after this
                            for k = 1, #vassal_faction_keys do
                                local other_vassal_faction_key = vassal_faction_keys[k];
                                local other_vassal_faction = cm:get_faction(other_vassal_faction_key);

                                if vassal_faction_keys[k] ~= vassal_faction_key then
                                    if not other_vassal_faction:at_war_with(vassal_enemy) then
                                        out("Forcing war between [" .. other_vassal_faction_key .. "] and [" .. vassal_enemy_name .. "]");
                                        cm:force_declare_war(other_vassal_faction_key, vassal_enemy_name, true, true);
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

local function vassalise(master_faction_key, vassal_faction_keys)
    out("vassalise() called, master_faction_key: " .. master_faction_key .. ", vassal faction_keys: " .. tostring(vassal_faction_keys));

    local human_factions = cm:get_human_factions();
    local player_1 = cm:get_faction(human_factions[1]);
    local player_2 = nil;
    -- only get player 2 if one exists
    if cm:is_multiplayer() then
        player_2 = cm:get_faction(human_factions[2]);
    end;

    for i = 1, #vassal_faction_keys do
        local vassal_faction_key = vassal_faction_keys[i];
        local vassal_faction = cm:get_faction(vassal_faction_key);

        if vassal_faction == player_1 or vassal_faction == player_2 then
            out("force_alliance called, faction_key_1: " .. master_faction_key .. ", faction_key_2: " .. vassal_faction_key);
            cm:force_alliance(master_faction_key, vassal_faction_key, true);
        else
            -- Force a faction to become the master of another faction
            out("force_make_vassal() called, master_faction_key: " .. master_faction_key .. ", vassal_faction_key: " .. vassal_faction_key);
            cm:force_make_vassal(master_faction_key, vassal_faction_key);
        end;
    end;
end;

local function create_alliance_network(faction_keys)
    out("create_alliance_network() called, faction_keys: " .. tostring(faction_keys));
    for _, faction_key_1 in ipairs(faction_keys) do
        local faction_1 = cm:get_faction(faction_key_1)

        for _, faction_key_2 in ipairs(faction_keys) do
            local faction_2 = cm:get_faction(faction_key_2);

            if faction_key_1 ~= faction_key_2 then
                if faction_1:at_war_with(faction_2) then
                    out("Forcing peace between [" .. faction_key_1 .. "] and [" .. faction_key_2 .. "]");
                    cm:force_make_peace(faction_1, faction_2);
                end;

                out("Forcing alliance between [" .. faction_key_1 .. "] and [" .. faction_key_2 .. "]");
                cm:force_alliance(faction_key_1, faction_key_2, true);
            end;
        end;
    end;
end;

local function create_diplomatic_contact_network(faction_keys)
    out("create_diplomatic_contact_network() called, faction_keys: " .. tostring(faction_keys));

    for _, faction_key_1 in ipairs(faction_keys) do
        for _, faction_key_2 in ipairs(faction_keys) do
            if faction_key_1 ~= faction_key_2 then
                establish_diplomatic_contact_and_reveal_regions(faction_key_1, faction_key_2);
            end;
        end;
    end;
end;

function hamskii_script()
    out("hamskii_script() called");
    if cm:is_new_game() then
        -- Start by putting all the factions that need to be at war with each other, at war with each other
        -- Do this before any calls to force_make_vassal to avoid running into a mess with factions asking allies to join

        cm:force_declare_war("wh_main_vmp_schwartzhafen", "wh_main_vmp_vampire_counts", false, false);

        cm:force_declare_war("wh_main_grn_greenskins", "wh_main_ksl_kislev", false, false);
        cm:force_declare_war("wh_main_grn_greenskins", "wh_main_vmp_vampire_counts", false, false);
        cm:force_declare_war("wh_main_grn_greenskins", "wh_main_vmp_schwartzhafen", false, false);
        establish_diplomatic_contact_and_reveal_regions("wh_main_grn_orcs_of_the_bloody_hand", "wh2_main_lzd_teotiqua");
        establish_diplomatic_contact_and_reveal_regions("wh_main_grn_orcs_of_the_bloody_hand", "wh2_dlc09_tmb_khemri");
        cm:force_declare_war("wh_main_grn_orcs_of_the_bloody_hand", "wh2_main_lzd_teotiqua", false, false);

        local greenskin_faction_keys = {
            "wh_main_grn_black_venom",
            "wh_main_grn_bloody_spearz",
            "wh_main_grn_broken_nose",
            "wh_main_grn_crooked_moon",
            "wh_main_grn_greenskins",
            "wh_main_grn_orcs_of_the_bloody_hand",
            "wh_main_grn_red_fangs",
            "wh_main_grn_scabby_eye",
            "wh_main_grn_skullsmasherz",
            "wh_main_grn_teef_snatchaz",
            "wh_main_grn_top_knotz"
        };
        for _, greenskin_faction_key_1 in ipairs(greenskin_faction_keys) do
            for _, greenskin_faction_key_2 in ipairs(greenskin_faction_keys) do
                if greenskin_faction_key_1 ~= greenskin_faction_key_2 then
                    local test_1 = (greenskin_faction_key_1 == "wh_main_grn_greenskins") and (greenskin_faction_key_2 == "wh_main_grn_orcs_of_the_bloody_hand");
                    local test_2 = (greenskin_faction_key_1 == "wh_main_grn_greenskins") and (greenskin_faction_key_2 == "wh_main_grn_crooked_moon");
                    local test_3 = (greenskin_faction_key_1 == "wh_main_grn_orcs_of_the_bloody_hand") and (greenskin_faction_key_2 == "wh_main_grn_crooked_moon");
                    local test_4 = (greenskin_faction_key_1 == "wh_main_grn_orcs_of_the_bloody_hand") and (greenskin_faction_key_2 == "wh_main_grn_greenskins");
                    local test_5 = (greenskin_faction_key_1 == "wh_main_grn_crooked_moon") and (greenskin_faction_key_2 == "wh_main_grn_greenskins");
                    local test_6 = (greenskin_faction_key_1 == "wh_main_grn_crooked_moon") and (greenskin_faction_key_2 == "wh_main_grn_orcs_of_the_bloody_hand");
                    if not test_1 or not test_2 or not test_3 or not test_4 or not test_5 or not test_6 then
                        cm:force_declare_war(greenskin_faction_key_1, greenskin_faction_key_2, false, false);
                    end;
                end;
            end;
        end;

        cm:transfer_region_to_faction("wh_main_trollheim_mountains_bay_of_blades", "wh_dlc08_nor_naglfarlings");
        cm:transfer_region_to_faction("wh_main_trollheim_mountains_sarl_encampment", "wh_dlc08_nor_naglfarlings");
        cm:transfer_region_to_faction("wh_main_trollheim_mountains_the_tower_of_khrakk", "wh_dlc08_nor_naglfarlings");
        cm:transfer_region_to_faction("wh_main_mountains_of_hel_altar_of_spawns", "wh_dlc08_nor_wintertooth");
        cm:transfer_region_to_faction("wh_main_mountains_of_hel_aeslings_conclave", "wh_dlc08_nor_wintertooth");
        --cm:force_declare_war("wh_dlc08_nor_norsca", "wh_dlc08_nor_wintertooth", false, false);
        cm:force_declare_war("wh_dlc08_nor_wintertooth", "wh_main_ksl_kislev", false, false);
        cm:force_declare_war("wh_dlc08_nor_norsca", "wh2_main_nor_aghol", false, false);
        cm:force_declare_war("wh_dlc08_nor_norsca", "wh2_main_nor_mung", false, false);
        cm:force_declare_war("wh_dlc08_nor_norsca", "wh2_main_nor_skeggi", false, false);

        establish_diplomatic_contact_and_reveal_regions("wh2_main_skv_clan_mors", "wh_main_grn_necksnappers");
        cm:force_declare_war("wh2_main_skv_clan_mors", "wh_main_grn_necksnappers", false, false);
        cm:force_declare_war("wh2_main_skv_clan_mors", "wh_main_grn_crooked_moon", false, false);
        cm:force_diplomacy("faction:wh2_main_skv_clan_mors", "faction:wh_main_grn_crooked_moon", "peace", false, false, true);
        cm:force_declare_war("wh2_main_skv_clan_mors", "wh_main_dwf_karak_izor", false, false);
        cm:force_diplomacy("faction:wh2_main_skv_clan_mors", "faction:wh_main_dwf_karak_izor", "peace", false, false, true);
        cm:force_declare_war("wh2_main_skv_clan_mors", "wh_main_grn_red_fangs", false, false);
        cm:force_declare_war("wh2_main_skv_clan_mors", "wh_main_dwf_karak_azul", false, false);

        cm:force_alliance("wh_main_emp_empire", "wh_main_dwf_dwarfs", true);
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

        establish_diplomatic_contact_and_reveal_regions("wh_main_dwf_dwarfs", "wh_main_dwf_kraka_drak");
        cm:make_region_seen_in_shroud("wh_main_dwf_dwarfs", "wh_main_northern_worlds_edge_mountains_karak_ungor");
        cm:make_region_seen_in_shroud("wh_main_dwf_dwarfs", "wh_main_rib_peaks_mount_gunbad");
        cm:make_region_seen_in_shroud("wh_main_dwf_dwarfs", "wh_main_death_pass_karak_drazh");
        cm:make_region_seen_in_shroud("wh_main_dwf_dwarfs", "wh_main_western_badlands_ekrund");
        cm:make_region_seen_in_shroud("wh_main_dwf_dwarfs", "wh_main_eastern_badlands_karak_eight_peaks");
        cm:make_region_seen_in_shroud("wh_main_dwf_dwarfs", "wh_main_blightwater_karak_azgal");
        cm:make_region_seen_in_shroud("wh_main_dwf_dwarfs", "wh_main_southern_badlands_galbaraz");

        cm:make_diplomacy_available("wh_main_vmp_schwartzhafen", "wh_main_vmp_mousillon");
        cm:transfer_region_to_faction("wh_main_eastern_sylvania_eschen", "wh_main_vmp_vampire_counts");
        cm:transfer_region_to_faction("wh_main_eastern_sylvania_waldenhof", "wh_main_vmp_vampire_counts");
        cm:transfer_region_to_faction("wh_main_western_sylvania_castle_templehof", "wh_main_vmp_schwartzhafen");
        cm:transfer_region_to_faction("wh_main_western_sylvania_fort_oberstyre", "wh_main_vmp_schwartzhafen");

        cm:force_alliance("wh_main_grn_greenskins", "wh_main_grn_orcs_of_the_bloody_hand", true);

        cm:transfer_region_to_faction("wh_main_death_pass_karak_drazh", "wh_main_grn_red_fangs");
        cm:transfer_region_to_faction("wh_main_western_badlands_ekrund", "wh_main_grn_teef_snatchaz");
        cm:force_confederation("wh_main_grn_greenskins", "wh_main_grn_red_eye");
        cm:force_confederation("wh_main_grn_crooked_moon","wh_main_grn_necksnappers");
        cm:force_confederation("wh_main_grn_orcs_of_the_bloody_hand", "wh2_main_grn_arachnos");

        cm:force_confederation("wh_dlc08_nor_norsca","wh_main_nor_skaeling");

        cm:force_confederation("wh2_main_def_har_ganeth", "wh2_main_def_ghrond");
        cm:force_confederation("wh2_main_def_cult_of_pleasure", "wh2_main_def_ssildra_tor");

        preserve_vassal_master_rules("wh_main_emp_empire", {
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

        preserve_vassal_master_rules("wh_main_dwf_dwarfs", {
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

        preserve_vassal_master_rules("wh_dlc05_wef_wood_elves", {
            "wh_dlc05_wef_argwylon",
            "wh_dlc05_wef_torgovann",
            "wh_dlc05_wef_wydrioth"
        });

        preserve_vassal_master_rules("wh_main_brt_bretonnia", {
            "wh_main_brt_bordeleaux",
            "wh_main_brt_carcassonne",
            "wh_main_brt_artois",
            "wh_main_brt_bastonne",
            "wh_main_brt_lyonesse",
            "wh_main_brt_parravon",
            "wh2_main_brt_knights_of_origo",
            "wh2_main_brt_knights_of_the_flame",
            "wh2_main_brt_thegans_crusaders"
        });

        preserve_vassal_master_rules("wh_dlc08_nor_norsca", {
            "wh_dlc08_nor_helspire_tribe",
            "wh_dlc08_nor_vanaheimlings"
        });
        preserve_vassal_master_rules("wh_dlc08_nor_wintertooth", {
            "wh_dlc08_nor_goromadny_tribe",
            "wh_main_nor_varg",
            "wh_dlc08_nor_naglfarlings"
        });

        preserve_vassal_master_rules("wh2_main_hef_saphery", { "wh2_main_hef_order_of_loremasters" });

        preserve_vassal_master_rules("wh2_main_def_naggarond", {
            "wh2_main_def_cult_of_pleasure",
            "wh2_main_def_bleak_holds",
            "wh2_main_def_clar_karond",
            "wh2_main_def_cult_of_excess",
            "wh2_main_def_deadwood_sentinels",
            "wh2_main_def_har_ganeth",
            "wh2_main_def_hag_graef",
            "wh2_main_def_karond_kar",
            "wh2_main_def_scourge_of_khaine",
            "wh2_main_def_the_forgebound"
        });

        preserve_vassal_master_rules("wh2_main_lzd_hexoatl", { "wh2_main_lzd_last_defenders" });

        preserve_vassal_master_rules("wh2_main_skv_clan_pestilens", { "wh2_main_skv_clan_septik" });

        preserve_vassal_master_rules("wh2_dlc09_tmb_khemri",
        {
            "wh2_dlc09_tmb_lybaras",
            "wh2_dlc09_tmb_exiles_of_nehek",
            "wh2_dlc09_tmb_numas",
            "wh2_dlc09_tmb_dune_kingdoms",
            "wh2_dlc09_tmb_rakaph_dynasty",
        });

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


        vassalise("wh_dlc08_nor_wintertooth", {
            "wh_dlc08_nor_goromadny_tribe",
            "wh_main_nor_varg",
            "wh_dlc08_nor_naglfarlings"
        });

        create_alliance_network({
            "wh2_main_hef_eataine", -- Inner
            "wh2_main_hef_caledor", -- Inner
            "wh2_main_hef_avelorn", -- Inner
            "wh2_main_hef_ellyrion", -- Inner
            "wh2_main_hef_saphery", -- Inner
            "wh2_main_hef_tiranoc", -- Outer
            "wh2_main_hef_nagarythe", -- Outer
            "wh2_main_hef_chrace", -- Outer
            "wh2_main_hef_cothique", -- Outer
            "wh2_main_hef_yvresse" -- Outer
        });

        -- establish_diplomatic_contact_and_reveal_regions("wh2_main_hef_eataine", "wh2_main_hef_order_of_loremasters");
        -- establish_diplomatic_contact_and_reveal_regions("wh2_main_hef_avelorn", "wh2_main_hef_order_of_loremasters");
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
            "wh2_main_def_the_forgebound"
        });

        create_alliance_network({
            "wh2_main_lzd_hexoatl",
            "wh2_main_lzd_itza",
            "wh2_main_lzd_sentinels_of_xeti",
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
            "wh2_main_skv_clan_pestilens",
            "wh2_main_skv_clan_septik"
        });
        create_alliance_network({
            "wh2_main_skv_clan_skyre",
            "wh2_main_skv_clan_eshin",
            "wh2_main_skv_clan_moulder",
            "wh2_main_skv_clan_pestilens"
        });
        vassalise("wh2_main_skv_clan_pestilens", { "wh2_main_skv_clan_septik" });

        vassalise("wh2_dlc09_tmb_khemri",
        {
            "wh2_dlc09_tmb_lybaras",
            "wh2_dlc09_tmb_exiles_of_nehek",
            "wh2_dlc09_tmb_numas",
            "wh2_dlc09_tmb_dune_kingdoms",
            "wh2_dlc09_tmb_rakaph_dynasty",
        });

        create_diplomatic_contact_network({
            "wh2_dlc09_tmb_followers_of_nagash",
            "wh2_main_vmp_necrarch_brotherhood",
            "wh2_main_vmp_strygos_empire",
            "wh2_main_vmp_the_silver_host",
            "wh_main_vmp_schwartzhafen"
        });

        vassalise("wh2_dlc09_tmb_followers_of_nagash",
        {
            "wh2_dlc09_tmb_followers_of_nagash",
            "wh2_main_vmp_necrarch_brotherhood",
            "wh2_main_vmp_strygos_empire",
            "wh2_main_vmp_the_silver_host"
        });
    end;
    out("hamskii_script() complete");
end;