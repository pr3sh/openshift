# **`Abstract`**
This document goes over Helm charts.
-  **`Table of contents`**:
  - [Openshift Services](#openshift-services)
  - [Defining External Services](#defining-external-services)
  - [Deploying Cloud Native Applications with JKube](#deploying-cloud-native-applications-with-JKube)
    - [OpenShift Maven Plug-In](#openshift-maven-plugin)
    - [OpenShift Maven Plug-In Goals](#openshift-maven-plugin-goals)
    - [Customizing OpenShift Resources](#customizing-openshift-resources)
 
#### **`Openshift Services`**:
- OpenShift services are typically comprised of a name and a selector.
- The service uses selectors to identify pods that should recieve application request sent to the service.
- OpenShift's internal DNS allows applications to discover services dynamically.
- OpenShift adds the **`svc.cluster.local`** domain suffix to the DNS resolver search path of all containers.
- Openshift also adds a **`service-name.project-name.svc.cluster.local`** host name to each service.

#### **`Defining External Services`**:
To create an internal service, use the **`oc create service externalname`** command as show below:
```shell
  oc create service externalname myservice \
      --external-name myhost.example.com
  ```
1. A typical service creates an endpoint resource.
2. If you do not use the **`--external-name`** flag, an endpoint resource **WONT** be created.
3. You can create the endpoint with a resource definition file, passed through the **`oc create -f`** command.
4. If you create an endpoint from a file, you can define multiple **`IP Addresses`** for the same external service that relies on OpenShift service load-balancing features.

#### **`Deploying Cloud-Native Applications with JKube`**:

Cloud-Native techonologies are those that are deisnged to build and run scalable applications in Cloud environments (Hybrid, Public, & Private Cloud). For example, **`Quarkus`** or **`JKube`** do not need **Dockerfiles** in order to create container images. Any Application that is deployed on OpenShift and deigned to use the serives provided by the platform can be classifierd as cloud-native application.

- **`Eclipse JKube`** is a set of open source plugins & libraries that can build container images via different stratgies and generates.
- **`JKube`** deploys Java applications to **`Kubernetes`** and **`OpenShift`** with little-to-no configurations.
- It is a result of refactoring and rebranding of Frabic8, targetiting Kubernetes and OpenShift.
- **`JKube`**, through its **`Maven`** plugins, supports several Java frameworks such as:
  1. Quarkus: *A modern full-stack, cloud-native framework, with a small memory footprint*
  2. **`Spring Boot`**: *Cloud-native developement framework based on the Spring Framework and auto configurations.*
  3. **`Vert.x`**: *Reactive, low-latency development framework based on asynchronous I/O and event steams.*
  4. **`Micronaut`**: *A modern full-stack toolkit for building modular, easily testable microservices and serverless apps.*
  5. **`Open Liberty`**: *A flexible server runtime for Java applications.*

###### **`OpenShift Maven Plug-In`**: 
You can use the Maven plug-in to deploy Java applications to OpenShift.
- To use the OpenShift Maven plug-in with a project, update the project's **`pom.xml`** file to enable and configure plug-in.
- You must add **plugin** entry to the **plugins** listings in the **build** section of the **`pom.xml`**.

> *Example of XML:*
```xml
  <build>
    <plugins>
      <plugin>
        <groupId>org.eclipse.jkube</groupId>
        <artifactId>openshift-maven-plugin</artifactId>
        <version>1.2.0</version>
        <executions>
          <execution>
            <goals>
              <goal>resource</goal>
              <goal>build</goal>
              <goal>apply</goal>
            </goals>
          </execution>
        </executions>
        <configuration>
          <!-- additional configuration here -->
        </configuration>
      </plugin>
    </plugins>
  </build>
```
###### **`OpenShift Maven Plug-In Goals`**:
The Maven plug-in goal represents a well-defined task in the software devlpment life-cycle. To execute a Maven plug-in goal, you can use the **`mvn`** command.
```zsh
[user@host sample-app]$ mvn <plug-in goal name> 
```
> *OpenShift Maven plug-in provides a set of goals to deal with the development of cloud-native Java applications.*

#### **`Helm Commands`:**
|         **`Command`**    |     **`Description`**              | 
|--------------------------|:---------------------------------:|  
| **`oc:resources`**       | Creates Kubernets & OpenShift resource descriptors.  Plug-in stores all generated descriptors in project's **`target/classes/META-INF/openshift`** subdirectory  | 
| **`oc:build`**           | Compiles & Packages Java app to create a binary artifact which is used to build aaplication container image. For generatic Java applications, the default image is **`quay.io/jkube/jkube-java-binary-s2i`**                 |   
| **`oc:apply`**           | Applies the generated resources to a connected OpenShift cluster.           |
| **`oc:deploy`**          | Similar to **`oc apply`**, except it runs in the background.   | 
| **`oc:undeploy`**        | Removes resources from the OpenShift cluster.     | 
| **`oc:watch`**           | Watches files for changes, which then triggers & redeployment.   |   

> **`JKube OpenShift Maven plug-in`** supports other goals, for more info [refer to this URL](https://www.eclipse.org/jkube/docs/openshift-maven-plugin)


###### **`Customizing OpenShift Resources`**:
In some scenarios, you may need to customize the generated resources & that can be done in two ways:
1. Add OpenShift resource **`YAML`** fragments to the project's **`src/main/jkube`** subdirectory.
- Add additional configuration to the project's **`pom.xml`** 

> Consider the below example which shows the contents of a **`src/main/jkube/route.yaml`**.

```yaml
spec:
    host: app.alternate.com
```
- This fragment changes the defualt host name of the application route to **`app.alternate.com`**. 
- Same concept can be applied to other Openshift resources such as:
   - **`Routes`**
   - **`Secrets`**
   - **`ConfigMap`**
   - **`DeploymentConfig`**
   - **`Deployment`**
   - **`Service`**

