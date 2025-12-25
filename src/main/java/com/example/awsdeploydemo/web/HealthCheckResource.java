package com.example.awsdeploydemo.web;

import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(HealthCheckResource.API)
@RequiredArgsConstructor
public class HealthCheckResource {

  private static final Logger LOGGER = LoggerFactory.getLogger(HealthCheckResource.class);

  public static final String API = "/api/health-check";

  @GetMapping
  public ResponseEntity<String> healthCheck() {
    LOGGER.info("[HealthCheckController][HTTP Health Check success!]");
    return ResponseEntity.ok().body("SUCCESS");
  }
}