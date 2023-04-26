APPS=("api" "docs" "web")

deploy_app_name=$1

if [ -z "$1" ]; then
  echo "Please select apps"
  exit 1
fi

if [[ ! " ${APPS[*]} " =~ " $1 " ]]; then
  echo "Not Found apps"
  exit 1
fi


deploy_app() {
  app_name=$1
  if [[ "$app_name" == "$deploy_app_name" ]]; then
    echo "Deploy app => $app_name"
    exit 0
  fi
}

for app in ${APPS[@]}; do
  case "$(cat ./.build_output)" in
    *"${app}:build: cache miss, executing"*) deploy_app "$app" ;;
    *"${app}:build: cache bypass, force"*) deploy_app "$app" ;;
    # Uncomment the first *) line to force deployment
    # *) deploy_app "$app" ;;
    *);;
  esac
done

echo "Can not deploy app => $app_name"
exit 1