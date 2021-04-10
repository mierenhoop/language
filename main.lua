local program = [[
nothing # ,
fizzbuzz 1-"fizz""buzz""fizzbuzz"4@7~#3%0=3@~-~#5%0=2*3@~-@.10@1+"nothing""fizzbuzz"3@#100=2+@~1+~$

main 2 "fizzbuzz" $
]]

local functions = {}

local stack = {}

for line in program:gmatch("[^\r\n]+") do
   local isprc, prcend, prc = string.find(line, "^%s*([a-z]+)%s")
   if not isprc then print "ohno" return end
   functions[prc] = line:sub(prcend + 1)
end

function execute(line)
   local pos = 1
   
   while pos <= #line do
      local isnum, numend, num = string.find(line, "^%s*([0-9]+)", pos)
      local isstr, strend, str = string.find(line, "^%s*\"([^\"]*)\"", pos)
      local isfun, funend, fun = string.find(line, "^%s*([~@%+%-%.#%$%%/=,%*])", pos)
      if isnum then
         table.insert(stack, tonumber(num))
         pos = numend
      elseif isstr then
         table.insert(stack, str)
         pos = strend
      elseif isfun then
         if fun == "~" then
            stack[#stack], stack[#stack - 1] = stack[#stack - 1], stack[#stack]
         elseif fun == "@" then
            -- idk if this works
            table.insert(stack, stack[#stack - table.remove(stack)])
         elseif fun == "+" then
            local l, r = stack[#stack - 1], stack[#stack]
            table.remove(stack)
            stack[#stack] = l + r
         elseif fun == "-" then
            local l, r = stack[#stack - 1], stack[#stack]
            table.remove(stack)
            stack[#stack] = l - r
         elseif fun == "." then
            print(table.remove(stack))
         elseif fun == "#" then
            table.insert(stack, stack[#stack])
         elseif fun == "$" then
            execute(functions[table.remove(stack)])
         elseif fun == "%" then
            local l, r = stack[#stack - 1], stack[#stack]
            table.remove(stack)
            stack[#stack] = l % r
         elseif fun == "/" then
            local l, r = stack[#stack - 1], stack[#stack]
            table.remove(stack)
            stack[#stack] = l / r
         elseif fun == "=" then
            local l, r = stack[#stack - 1], stack[#stack]
            table.remove(stack)
            stack[#stack] = ((l == r) and 1 or 0)
         elseif fun == "," then
            table.remove(stack)
         elseif fun == "*" then
            local l, r = stack[#stack - 1], stack[#stack]
            table.remove(stack)
            stack[#stack] = l * r
         end
         pos = funend
      else
         print("unknown")
      end
      pos = pos + 1
   end
end

execute(functions["main"])

--print "-- Current stack --"
--for _, v in ipairs(stack) do
--   print(v)
--end
