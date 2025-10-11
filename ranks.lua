sepgp.rank_prio = {
	{'Professor Oak(MS)', 'Branch Manager(MS)', 'Oakaholic(MS)', 'Big Oak(MS)'},
	{'Professor Oak(OS)', 'Branch Manager(OS)', 'Oakaholic(OS)', 'Big Oak(OS)'},
	{'Lil Oak(MS)', 'Twiglet(MS)', 'Sprout(MS)', 'Mulch(MS)'},
	{'Lil Oak(OS)', 'Twiglet(OS)', 'Sprout(OS)', 'Mulch(OS)'},
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
