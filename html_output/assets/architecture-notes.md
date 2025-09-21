# Architecture Diagrams and Assets

## Available Diagrams

### network-diagrams.svg
- ISE High Availability Architecture
- Shows dual data center setup
- PAN/MnT/PSN node distribution
- Created for blog posts about ISE deployment

## Planned Diagrams

### Zero Trust Architecture
- [ ] Policy Decision Points (ISE)
- [ ] Policy Enforcement Points (Switches, FW)
- [ ] Policy Information Points (AD, SIEM, MDM)
- [ ] Trust zones and boundaries

### Network Automation Flow
- [ ] Git → CI/CD → Ansible → Devices
- [ ] Event-driven automation loops
- [ ] Testing and validation stages

### Microservices Communication
- [ ] Service mesh overview
- [ ] Event bus architecture
- [ ] Database per service pattern

## Screenshot Guidelines

When adding screenshots:
1. Remove any sensitive information
2. Use consistent window size (1920x1080 recommended)
3. Highlight important areas with red boxes
4. Save as PNG for clarity

## Code Output Examples

Store terminal output captures here for blog posts:
- ISE CLI outputs
- Python script execution
- Ansible playbook runs
- Docker/K8s deployments

## Performance Metrics

Graphs and charts showing:
- Authentication rates
- CPU/Memory usage patterns
- Network throughput
- Response time distributions

---

Note: All assets should be referenced in blog posts using relative paths:
```asciidoc
image::../04_ASSETS/network-diagrams.svg[ISE Architecture, 800, 600]
```