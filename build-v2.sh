
docker build -t spring-argocd-app:v2 .

docker tag spring-argocd-app:v2 localhost:5000/spring-argocd-app:v2
#docker login localhost:5000
docker push localhost:5000/spring-argocd-app:v2