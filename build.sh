
docker build -t spring-argocd-app:v1 .

docker tag spring-argocd-app:v1 localhost:5000/spring-argocd-app:v1
#docker login localhost:5000
docker push localhost:5000/spring-argocd-app:v1
#docker push chavanga/spring-argocd-app:v1