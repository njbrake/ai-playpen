FROM docker/sandbox-templates:claude-code

USER root

RUN npm install -g opencode-ai @openai/codex

RUN pip3 install --break-system-packages mistral-vibe

USER agent

CMD ["/bin/bash"]
