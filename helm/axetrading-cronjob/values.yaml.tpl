replicaCount: 1

image:
  repository: ""
  pullPolicy: ${imagePullPolicy}
  # Overrides the image tag whose default is the chart appVersion.
  tag: ""

imagePullSecrets: []
nameOverride: ""
fullnameOverride: ${fullNameOverride}


podAnnotations: {}
podLabels: {}

podSecurityContext: {}

securityContext: {}

resources:
   limits:
     memory: ${resources.memory}
   requests:
     cpu: ${resources.cpu}
     memory: ${resources.memory}

secretsStore:
  %{~ if awsSecrets != null ~}
  enabled: true
  provider: aws
  awsSecrets:
    %{~ for secret in awsSecrets ~}
    - ${secret}
    %{~ endfor ~}
  %{~ endif ~}
  %{~ if awsSecrets == null ~}
  enabled: false
  %{~ endif ~}

persistence:
  enabled: true
  accessMode: ReadWriteMany
  storageSize: 2Gi
  storageClass: efs
  storageClassName: ""
  mountPath: ""
  annotations: {}

efsProvisioner:
  efsFileSystemId: ""
  reclaimPolicy: retain

cronJob:
  create: %{ if length(cronJobCommands) > 0 && cronJobSchedule != "" }true%{~ else }false%{~ endif }
  cronJobSchedule: ${cronJobSchedule}
  cronJobCommands: []
