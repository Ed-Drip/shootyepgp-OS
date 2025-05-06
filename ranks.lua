sepgp.rank_prio = {
	{'Guild Master(MS)', 'Officer(MS)', 'Veteran(MS)', 'Core Raider(MS)'},
	{'Guild Master(OS)', 'Officer(OS)', 'Veteran(OS)', 'Core Raider(OS)'},
	{'Raider(MS)', 'Alt(MS)>5000', 'Cossack(MS)>100'},
	{'Raider(OS)', 'Alt(OS)>5000', 'Cossack(OS)>100'},
	{'Cossack(MS)', 'Newcomer(MS)', 'Alt(MS)', 'Muted(MS)'},
	{'Cossack(OS)', 'Newcomer(OS)', 'Alt(OS)', 'Muted(OS)'},
}

function sepgp:rankPrio_index(rank, spec, ep)
	rank_spec = rank..'('..spec..')'
	for i, v in ipairs(sepgp.rank_prio) do
		for j, r in ipairs(v) do
			if r == rank_spec then
				return i
			else
				found,_,rr,barrier_ep = string.find(r, "(.*)>(%d+)")
				if found and rr == rank_spec and ep > tonumber(barrier_ep) then
					return i
				end
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