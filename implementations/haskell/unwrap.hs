-- unwrap.hs: intelligently purge carriage returns from plain text input
-- Greg Benison, 2011
--
-- input (stdin):   plain text file (stdin)
-- output (stdout): text with carriage returns removed,
--                  except at paragraph breaks and similar places

import Char

main = interact (unlines . unWrapLines . lines)

unWrapLines::[[Char]]->[[Char]]
unWrapLines = (map (stringJoin " ")) . innerUnWrap

innerUnWrap::[[Char]]->[[[Char]]]
innerUnWrap = foldr process []
  where process line [] = [[line]]
        process line ((x:xs):ys) | shouldMerge line x = (line:(x:xs)):ys
        process line rest = [line]:rest
          
shouldMerge::[Char]->[Char]->Bool
shouldMerge "" _ = False
shouldMerge _ "" = False
shouldMerge _ nextline | (not . isAlphaNum . head) nextline = False
shouldMerge line nextline | length (line ++ " " ++ (head . words) nextline) <
                              length nextline = False
shouldMerge _ _  = True

stringJoin::[Char]->[[Char]]->[Char]
stringJoin delim strs = foldr process "" strs
  where process x ""   = x
        process x rest = x ++ (delim ++ rest)
        
               
