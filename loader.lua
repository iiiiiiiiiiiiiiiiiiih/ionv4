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
			return game:HttpGet('https://raw.githubusercontent.com/LionKing123412/LionV5/'..readfile('LionV5/profiles/commit.txt')..'/'..select(1, path:gsub('LionV5/', '')), true)
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		if path:find('.lua') then
			res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.\n'..res
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end
local function wipeFolder(path)
	if not isfolder(path) then return end
	for _, file in listfiles(path) do
		if file:find('loader') then continue end
		if isfile(file) and select(1, readfile(file):find('--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.')) == 1 then
			delfile(file)
		end
	end
end
for _, folder in {'LionV5', 'LionV5/games', 'LionV5/profiles', 'LionV5/assets', 'LionV5/libraries', 'LionV5/guis'} do
	if not isfolder(folder) then
		makefolder(folder)
	end
end
if not shared.VapeDeveloper then
	local commit = 'main'
	local ok, res = pcall(function()
		return game:HttpGet('https://api.github.com/repos/LionKing123412/LionV5/commits/main', true)
	end)
	if ok and res then
		local h = res:match('"sha":"([a-f0-9]+)"')
		if h and #h == 40 then
			commit = h
		end
	end
	if commit == 'main' or (isfile('LionV5/profiles/commit.txt') and readfile('LionV5/profiles/commit.txt') or '') ~= commit then
		wipeFolder('LionV5')
		wipeFolder('LionV5/games')
		wipeFolder('LionV5/guis')
		wipeFolder('LionV5/libraries')
	end
	writefile('LionV5/profiles/commit.txt', commit)
end
return loadstring(downloadFile('LionV5/main.lua'), 'main')({
    Username = shared.ValidatedUsername
})
