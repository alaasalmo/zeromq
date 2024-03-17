reference:
https://zeromq.org/languages/python/

docker volume create logs
docker run -d -v logs:/logs busybox ls /logs


docker network create network_example
docker network ls


docker build -t server:v2 . -f Dockerfile-s
docker build -t client1:v2 . -f Dockerfile-c1
docker build -t client2:v2 . -f Dockerfile-c2

docker tag da45beed3ba4 alaasalmo/zeromq-server:v2
docker tag 2fbece256677 alaasalmo/zeromq-client1:v2
docker tag db46f8388885 alaasalmo/zeromq-client2:v2

docker push alaasalmo/zeromq-server:v2
docker push alaasalmo/zeromq-client1:v2
docker push alaasalmo/zeromq-client2:v2

--For docker only
docker run -v /tmp2:/logs -p 5555:5555 --network network_example --name server -d server:v2
docker run -v /tmp2:/logs -p 5555:5555 --network network_example --name client1 -d client1:v2
docker run -v /tmp2:/logs -p 5555:5555 --network network_example --name client2 -d client2:v2

Create PV & PVC
kubectl apply -f zeromq-pv.yaml
kubectl apply -f zeromq-pvc.yaml



Create Server for zeroMQ:
vi zeromq-server.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: zeromq-server-deployment
  labels:
    app: zeromq
spec:
  replicas: 2
  selector:
    matchLabels:
      app: zeromq
  template:
    metadata:
      labels:
        app: zeromq
    spec:
      containers:
      - name: zeromq-server
        image: alaasalmo/zeromq-server:v2

vi service.yaml

apiVersion: v1
kind: Service
metadata:
  name: server
spec:
  selector:
    app.kubernetes.io/name: zeromq
  ports:
    - protocol: TCP
      port: 5555
      targetPort: 5555



Create Client1 for zeroMQ:
vi zeromq-client1.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: zeromq-client1-deployment
  labels:
    app: zeromq
spec:
  replicas: 2
  selector:
    matchLabels:
      app: zeromq
  template:
    metadata:
      labels:
        app: zeromq
    spec:
      containers:
      - name: zeromq-client1
        image: alaasalmo/zeromq-client1:v2


Create Client1 for zeroMQ:
vi zeromq-client1.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: zeromq-client2-deployment
  labels:
    app: zeromq
spec:
  replicas: 2
  selector:
    matchLabels:
      app: zeromq
  template:
    metadata:
      labels:
        app: zeromq
    spec:
      containers:
      - name: zeromq-client2
        image: alaasalmo/zeromq-client2:v2


kubectl apply -f zeromq-server.yaml
kubectl apply -f zeromq-client1.yaml
kubectl apply -f zeromq-client2.yaml


