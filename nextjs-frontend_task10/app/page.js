"use client";

import { Button } from "@/components/ui/button";
import Typed from "typed.js";
import React, { useRef, useEffect, useState } from "react";
import Link from "next/link";

export default function Home() {
  const el = useRef(null);
  const [response, setBlog] = useState();

  // Hardcoded Typed.js strings
  const typedStrings = ["DevOps", "Cloud", "Developer"];

  useEffect(() => {
    document.title = "Nisha's Developer Portfolio";

    const fetchData = async () => {
      try {
        const articlesRes = await fetch(
          `http://nisha-428808545.us-east-2.elb.amazonaws.com/api/articles?populate=*`,
          { cache: "no-store" }
        );
        const articles = await articlesRes.json();
        setBlog(articles);
      } catch (err) {
        console.error("Failed to fetch blog articles:", err);
      }
    };

    fetchData();
  }, []);

  useEffect(() => {
    if (!el.current) return;

    const typed = new Typed(el.current, {
      strings: typedStrings,
      typeSpeed: 50,
      loop: true,
    });

    return () => {
      typed.destroy();
    };
  }, []);

  return (
    <main>
      <section className="container px-4 py-10 mx-auto lg:h-128 lg:space-x-8 lg:flex lg:items-center">
        <div className="w-full text-center lg:text-left lg:w-1/2 lg:-mt-8">
          <h1 className="text-3xl leading-snug text-gray-800 dark:text-gray-200 md:text-4xl">
            <span className="font-semibold">My name is</span> Nisha
            <br className="hidden lg:block" />I work as{" "}
            <span className="font-semibold underline decoration-primary">
              <span ref={el} />
            </span>
          </h1>
          <p className="mt-4 text-lg text-gray-500 dark:text-gray-300">
            DevOps intern @ Pearl thoughts
          </p>
        </div>
        <div className="w-full mt-4 lg:mt-0 lg:w-1/2">
          <img
            src="https://www.creative-tim.com/twcomponents/svg/website-designer-bro-purple.svg"
            alt="tailwind css components"
            className="w-full h-full max-w-md mx-auto"
          />
        </div>
      </section>

      {/* Testimonials Section */}
      <section className="py-12 bg-white dark:bg-gray-900">
        <div className="container px-4 mx-auto">
          <div className="text-center mb-12">
            <h2 className="text-4xl font-bold text-gray-800 dark:text-gray-200">
              {/* What Our Readers Say */}
            </h2>
            <p className="mt-4 text-lg text-gray-500 dark:text-gray-300">
              {/* Hear from our satisfied Readers! */}
            </p>
          </div>
          <div className="flex flex-wrap justify-center">
            {/* Testimonials */}
            {["Cloud", "DevOps Tool", "Containers"].map((name, i) => (
              <div key={i} className="w-full sm:w-1/2 lg:w-1/3 p-4">
                <div className="p-6 bg-white rounded-lg shadow-lg dark:bg-gray-800 transform transition duration-500 hover:scale-105 text-center">
                  <p className="text-gray-600 dark:text-gray-400">
                    {
                      [
                        "Cloud: AWS (EC2, ELB, ALB, S3, VPC, CloudFront, Route53, RDS, Fargate), Azure (AKS, VMs, NSGs)",
                        "DevOps Tools: Terraform, Ansible, Jenkins, GitHub Actions, ArgoCD, Helm, SonarQube, Trivy",
                        "Containers: Docker, Kubernetes, NGINX. Monitoring: AWS CloudWatch, Prometheus, Grafana",
                      ][i]
                    }
                  </p>
                  <h3 className="mt-4 text-xl font-semibold text-gray-800 dark:text-gray-200">
                    {name}
                  </h3>
                  <p className="text-gray-500 dark:text-gray-300">
                    {
                      [
                        // "CEO, Company A",
                        // "Marketing Director, Company B",
                        // "CTO, Company C",
                      ][i]
                    }
                  </p>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Blog Section */}
      <section className="py-12 bg-gray-100 dark:bg-gray-900">
        <div className="container px-4 mx-auto">
          <div className="text-center mb-12">
            <h2 className="text-4xl font-bold text-gray-800 dark:text-gray-200">
              Top Blogs
            </h2>
            <p className="mt-4 text-lg text-gray-500 dark:text-gray-300">
              Check out our most popular blog posts
            </p>
          </div>
          <div className="flex flex-wrap justify-center">
            {response &&
              response.data.map((data) => (
                <div key={data.id} className="w-full sm:w-1/2 lg:w-1/3 p-4">
                  <div className="p-6 bg-white rounded-lg shadow-lg dark:bg-gray-800 transform transition duration-500 hover:scale-105">
                    <img
                      src={data.cover?.url}
                      alt={data.title}
                      className="w-full h-64 object-cover rounded-t-lg"
                    />
                    <div className="mt-4">
                      <h3 className="text-xl font-semibold text-gray-800 dark:text-gray-200">
                        {data.title}
                      </h3>
                      <p className="mt-2 text-gray-600 dark:text-gray-400">
                        {data.description.split(" ").slice(0, 10).join(" ") +
                          "..."}
                      </p>
                      <Link href={`/blogpost/${data.slug}`}>
                        <Button className="m-2" variant="outline">
                          Read More
                        </Button>
                      </Link>
                    </div>
                  </div>
                </div>
              ))}
          </div>
        </div>
      </section>
    </main>
  );
}
