local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end
local delfile = delfile or function(file)
	writefile(file, '')
end
local function downloadFile(path, func)
	if not isfile(path) then
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/iiiiiiiiiiiiiiiiiiih/ionv4/'..readfile('ionv4/profiles/commit.txt')..'/'..select(1, path:gsub('ionv4/', '')), true)
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		if path:find('.lua') then
			res = '--ionv4\n'..res
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end
local function wipeFolder(path)
	if not isfolder(path) then return end
	for _, file in listfiles(path) do
		if file:find('loader') then continue end
		if isfile(file) and select(1, readfile(file):find('--ionv4')) == 1 then
			delfile(file)
		end
	end
end
for _, folder in {'ionv4', 'ionv4/games', 'ionv4/profiles', 'ionv4/assets', 'ionv4/libraries', 'ionv4/guis'} do
	if not isfolder(folder) then
		makefolder(folder)
	end
end
if not shared.VapeDeveloper then
	local commit = 'main'
	local ok, res = pcall(function()
		return game:HttpGet('https://api.github.com/repos/iiiiiiiiiiiiiiiiiiih/ionv4/commits/main', true)
	end)
	if ok and res then
		local h = res:match('"sha":"([a-f0-9]+)"')
		if h and #h == 40 then
			commit = h
		end
	end
	if commit == 'main' or (isfile('ionv4/profiles/commit.txt') and readfile('ionv4/profiles/commit.txt') or '') ~= commit then
    if isfile('ionv4/main.lua') then delfile('ionv4/main.lua') end
    	wipeFolder('ionv4')
    	wipeFolder('ionv4/games')
    	wipeFolder('ionv4/guis')
    	wipeFolder('ionv4/libraries')
	end
	writefile('ionv4/profiles/commit.txt', commit)
end
return loadstring(downloadFile('ionv4/main.lua'), 'main')({
    Username = shared.ValidatedUsername
})
