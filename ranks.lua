sepgp.rank_prio = {
	{'Guild Master(MS)', 'Raid Leader(MS)', 'Class Leader(MS)', 'Core Raider(MS)'},
	{'Raider(MS)'},
	{'Guild Master(OS)', 'Raid Leader(OS)', 'Class Leader(OS)', 'Core Raider(OS)'},
	{'Cossack(MS)', 'Newcommer(MS)'},
	{'Raider(OS)'},
	{'Alt(MS)'},
	{'Cossack(OS)', 'Newcommer(OS)'},
	{'Alt(OS)'}
}

function sepgp:rankPrio_index(rank, spec)
	rank_spec = rank..'('..spec..')'
	for i, v in ipairs(sepgp.rank_prio) do
		for j, r in ipairs(v) do
			if r == rank_spec then
				return i
			end
		end
	end
	self:defaultPrint("Unknown rank prio for "..rank_spec..", consider editing ranks.lua")
	return nil
end

function sepgp:overrideRank(name, rank)
	if (name) then
		for i = 1, GetNumGuildMembers(1) do
			local member_name,g_rank,_,_,_,_,_,officernote,_,_ = GetGuildRosterInfo(i)
			if (member_name == name) then
				local _,_,prefix,old_rank,suffix = string.find(officernote or "","(.*)%[(.+)%](.*)")
				if (not prefix) then
					prefix = ""
					suffix = officernote
				end

				if (not rank or rank == '') then
					GuildRosterSetOfficerNote(i,string.format("%s%s",prefix,suffix),true)
					rank = g_rank
				else
					GuildRosterSetOfficerNote(i,string.format("%s[%s]%s",prefix,rank,suffix),true)
				end

				self:defaultPrint(string.format("%s rank is now recognised as %s.",name,rank))
				self:refreshPRTablets()
				return
			end
		end
	end
end

function sepgp:parseRank(name,officernote)
  if (officernote) then
    local _,_,_,rank,_ = string.find(officernote or "","(.*)%[(.+)%](.*)")
    if type(rank)=="string" and (string.len(rank) < 13) then
			return rank
    end
  else
    for i=1,GetNumGuildMembers(1) do
      local g_name, _, _, _, g_class, _, g_note, g_officernote, _, _ = GetGuildRosterInfo(i)
      if (name == g_name) then
        return self:parseRank(g_name, g_officernote)
      end
    end
  end
  return nil
end