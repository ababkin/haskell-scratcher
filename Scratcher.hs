
import Control.Applicative ((<$>))
import Control.Monad (mapM_)

main :: IO ()
main = do
  libdeps <- lines <$> readFile "libdeps"
  usrdeps <- lines <$> readFile "usrdeps"

  putStr "default: docker-integer-gmp docker-integer-simple\n\nroot:\n"
  putStr "\t@mkdir root\nroot/bin: | root\n\t@mkdir root/bin\nroot/etc: | root\n\t@mkdir root/etc\nroot/bin/sh: | root/bin\n\t@cp -L /bin/sh root/bin/\nroot/lib: | root\n\t@mkdir root/lib\nroot/lib/x86_64-linux-gnu: | root/lib\n\t@mkdir root/lib/x86_64-linux-gnu\n"

  mapM_ (\ld -> do
      putStrLn $ "root/lib/x86_64-linux-gnu/" ++ ld ++ ": | root/lib/x86_64-linux-gnu"
      putStrLn $ "\t@cp -L /lib/x86_64-linux-gnu/" ++ ld ++ " root/lib/x86_64-linux-gnu/"
    ) libdeps

  putStr "root/lib64: | root\n\t@mkdir root/lib64\nroot/lib64/ld-linux-x86-64.so.2: | root/lib64\n\t@cp -L /lib64/ld-linux-x86-64.so.2 root/lib64/\nroot/etc/protocols:  | root/etc\n\t@cp -L /etc/protocols root/etc/\nroot/etc/services:  | root/etc\n\t@cp -L /etc/services root/etc/\nroot/usr: | root\n\t@mkdir root/usr\nroot/usr/lib: | root/usr\n\t@mkdir root/usr/lib\nroot/usr/lib/x86_64-linux-gnu: | root/usr/lib\n\t@mkdir root/usr/lib/x86_64-linux-gnu\nroot/usr/lib/x86_64-linux-gnu/gconv: | root/usr/lib/x86_64-linux-gnu\t@mkdir root/usr/lib/x86_64-linux-gnu/gconv\n"

  mapM_ (\ld -> do
      putStrLn $ "root/usr/lib/x86_64-linux-gnu/" ++ ld ++ ": | root/usr/lib/x86_64-linux-gnu"
      putStrLn $ "\t@cp -L /usr/lib/x86_64-linux-gnu/" ++ ld ++ " root/usr/lib/x86_64-linux-gnu/"
    ) usrdeps

  
  let libdepspaths = unwords $ map ("root/lib/x86_64-linux-gnu/" ++) libdeps
      usrdepspaths = unwords $ map ("root/usr/lib/x86_64-linux-gnu/" ++) usrdeps

  putStrLn "\n\n"
  putStrLn $ "docker-integer-gmp: | root/bin/sh " ++ usrdepspaths ++ " " ++ libdepspaths
  putStrLn "\t@tar -cC root .|docker import - haskell-scratch:integer-gmp"

  putStrLn "\n"
  putStrLn $ "docker-integer-simple: | root/bin/sh " ++ usrdepspaths ++ " " ++ libdepspaths
  putStrLn "\t@tar -c --exclude=libgmp.so.10 -C root .|docker import - haskell-scratch:integer-simple"

  putStrLn "\n"
  putStrLn "clean:\n\t@rm -rf root\n\n.PHONY: default docker-integer-gmp docker-integer-simple clean"

