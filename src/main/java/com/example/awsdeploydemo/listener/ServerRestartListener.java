package com.example.awsdeploydemo.listener;

import java.util.concurrent.atomic.AtomicBoolean;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

@Component
public class ServerRestartListener {

  private static final Logger LOGGER = LoggerFactory.getLogger(ServerRestartListener.class);

  private final AtomicBoolean status = new AtomicBoolean(false);

  public ServerRestartListener() {
    doLog();
  }

  private void doLog() {
    if (status.compareAndSet(false, true)) {
      LOGGER.error("TEST DEPLOYMENT: Server restart detected");
    }
  }
}
