function hamskii_script()
    if cm:is_new_game() then
        -- call your script functions here that you only want to run at the start of a campaign.
        
        -- Force a certain stance of a faction towards another
        -- force_diplomacy("faction_key", "target_faction", "type listed below", offer, accept)

        force_diplomacy_new("wh_main_emp_middenland", "wh_main_emp_empire", "vassal", true, true);
        -- TODO: Try force_diplomacy_new if force_diplomacy doesn't work
    else
        -- call functions here that you want to fire every time you load the game.
    end;
end;