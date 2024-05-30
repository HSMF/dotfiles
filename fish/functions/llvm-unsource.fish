function llvm-unsource
    set -l index (contains -i -- "/usr/local/opt/llvm/bin" $PATH)

     if set -q index[1]
         set -e PATH[$index]
     else
         return 1
     end
end
