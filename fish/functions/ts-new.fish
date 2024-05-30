function ts-new --description 'creates a new typescript project'
    set -l arg $argv[1]
    command mkdir "$arg" && 
    cd "$arg" &&
    command yarn init &&
    command cp -r ~/dociq/config/{*,.*} . &&
    yarn add --dev @types/node @types/jest @typescript-eslint/eslint-plugin @typescript-eslint/parser eslint eslint-config-google eslint-plugin-unicorn jest prettier ts-jest typescript
end
