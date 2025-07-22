sepgp.rank_prio = {
	{'Guild Master(MS)', 'Officer(MS)', 'Veteran(MS)', 'Core Raider(MS)'},
	{'Guild Master(OS)', 'Officer(OS)', 'Veteran(OS)', 'Core Raider(OS)'},
	{'Raider(MS)', 'Alt(MS)>5000', 'Cossack(MS)>100'},
	{'Raider(OS)', 'Alt(OS)>5000', 'Cossack(OS)>100'},
	{'Cossack(MS)', 'Newcomer(MS)', 'Alt(MS)', 'Muted(MS)'},
	{'Cossack(OS)', 'Newcomer(OS)', 'Alt(OS)', 'Muted(OS)'},
}

function sepgp:rankPrio_index(rank, spec, ep)
	local rank_spec = rank..'('..spec..')'
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
	if (rank and string.find(rank, "(%d+)")) then
		self:defaultPrint("rank can't have numbers")
		return
	end

	if (name) then
		local m = sepgp:findGuildMember(name)
		if (not m) then 
			self:defaultPrint(string.format("can't find guild member %s",name))
			return
		end

		local _,_,prefix,old_rank,suffix = string.find(m.officernote,"(.*)%[(.+)%](.*)")
		if (not prefix) then
			prefix = ""
			suffix = m.officernote
		end

		if (not rank or rank == '') then
			GuildRosterSetOfficerNote(m.guildIndex,string.format("%s%s",prefix,suffix),true)
			rank = m.rank
		else
			GuildRosterSetOfficerNote(m.guildIndex,string.format("%s[%s]%s",prefix,rank,suffix),true)
		end

		self:defaultPrint(string.format("%s rank is now recognized as %s.",name,rank))
		self:refreshPRTablets()
	end
end

function sepgp:parseRank(name,officernote)
  if (officernote) then
    local _,_,_,rank,_ = string.find(officernote,"(.*)%[(.+)%](.*)")
		return rank
  else
		local m = sepgp:findGuildMember(name)
		if (m) then return sepgp:parseRank(name, m.officernote) end
  end
  return nil
end