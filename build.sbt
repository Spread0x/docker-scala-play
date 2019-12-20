name := """api"""

version := "1.0"

lazy val root = (project in file(".")).enablePlugins(PlayScala)

resolvers += Resolver.sonatypeRepo("snapshots")

scalaVersion := "2.13.1"

libraryDependencies += guice
libraryDependencies += "org.scalatestplus.play" %% "scalatestplus-play" % "5.0.0-2019-11-26-d81a8da-SNAPSHOT" % Test
libraryDependencies += "com.h2database" % "h2" % "1.4.194"
