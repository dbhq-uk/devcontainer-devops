# Contributing to DevOps DevContainer

Thank you for your interest in contributing! This document provides guidelines and instructions for contributing to this project.

## 🌟 How to Contribute

### Reporting Issues

- Use the GitHub issue tracker
- Check if the issue already exists
- Provide detailed information:
  - Steps to reproduce
  - Expected vs actual behavior
  - Tool versions
  - Error messages/logs

### Suggesting Enhancements

- Open an issue with the "enhancement" label
- Clearly describe the feature
- Explain the use case and benefits
- Provide examples if possible

### Pull Requests

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow the coding standards
   - Update documentation
   - Add tests if applicable

4. **Test your changes**
   ```bash
   bash tests/validate-tools.sh
   bash tests/integration-test.sh
   ```

5. **Commit your changes**
   ```bash
   git commit -m "feat: add new feature"
   ```
   
   Use conventional commit messages:
   - `feat:` New feature
   - `fix:` Bug fix
   - `docs:` Documentation changes
   - `chore:` Maintenance tasks
   - `refactor:` Code refactoring
   - `test:` Test additions/changes

6. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

7. **Create a Pull Request**

## 🔧 Development Guidelines

### Adding New Tools

1. **Create installation script**
   ```bash
   files/scripts/install-<tool-name>.sh
   ```

2. **Follow the template:**
   ```bash
   #!/bin/bash
   set -e

   VERSION=${1:-"<default-version>"}

   echo "Installing <tool> version ${VERSION}..."

   # Download with checksum validation
   curl -LO "<download-url>"
   curl -LO "<checksum-url>"
   sha256sum -c <checksum-file>

   # Install
   # ... installation steps ...

   # Verify
   <tool> --version

   echo "<tool> ${VERSION} installed successfully"
   ```

3. **Update Dockerfile**
   - Add ARG for version
   - Add RUN command to install script
   - Update in correct order (least to most likely to change)

4. **Add to validation script**
   ```bash
   validate_tool "<tool>" "<tool> --version" || ((FAILURES++))
   ```

5. **Update README.md** with tool information

### Version Updates

- Update version ARGs in Dockerfile
- Update version in devcontainer.json build args
- Test the build thoroughly
- Update CHANGELOG.md

### Testing Changes

Always test in the actual devcontainer:

1. Switch `.devcontainer/devcontainer.json` to the local build - comment out the
   `"image"` line and uncomment the `"build"` block. It pulls the published
   image by default, which would not contain your changes.
2. Rebuild the container
3. Run validation: `bash tests/validate-tools.sh`
4. Run integration tests: `bash tests/integration-test.sh`
5. Test common workflows manually

Take care not to commit that switch. CI builds from the `Dockerfile` regardless,
so leaving `"image"` active is correct for everyone who is not changing the
image itself.

### What CI checks

Opening a pull request runs the `lint` job (`bash -n` and `shellcheck` over
every script, a JSON parse over every JSON file, `hadolint` over the
Dockerfile), then builds `linux/amd64` and `linux/arm64` and runs
`tests/run-all-tests.sh` inside each image. Nothing is published from a pull
request.

You can run the lint checks locally before pushing:

```bash
shellcheck -x -S warning .devcontainer/files/install/*.sh tests/*.sh scripts/*.sh
hadolint --config .hadolint.yaml .devcontainer/Dockerfile
```

**The image builds for two architectures, so never hardcode one.** Source
`_arch.sh` in any install script that downloads an architecture-specific
artefact - see the README's "Adding New Tools".

### Documentation

- Keep README.md up to date
- Document new features in detail
- Update CHANGELOG.md
- Add inline comments for complex logic

## 📋 Code Style

### Shell Scripts

- Use `#!/bin/bash` shebang
- Always use `set -e` for error handling
- Add descriptive comments
- Use meaningful variable names
- Quote variables: `"${VARIABLE}"`
- Validate inputs

### Dockerfile

- One logical action per RUN command when possible
- Combine related commands to reduce layers
- Clean up in the same layer as installation
- Use multi-line format for readability
- Comment each section

### JSON/YAML

- Use 2-space indentation
- Validate syntax before committing
- Keep alphabetically organized where logical

## 🧪 Testing Requirements

### For New Tools

- Installation script must include version pinning
- Checksum validation required
- Add to validation script
- Add basic integration test

### For Bug Fixes

- Reproduce the bug
- Add test to prevent regression
- Verify fix in clean container

### For Features

- Add appropriate tests
- Update documentation
- Ensure backward compatibility

## 📝 Pull Request Checklist

- [ ] Code follows project style guidelines
- [ ] Tests pass locally
- [ ] Documentation updated
- [ ] CHANGELOG.md updated
- [ ] Commit messages follow conventional commits
- [ ] No merge conflicts
- [ ] Tested in actual devcontainer
- [ ] All new scripts are executable (`chmod +x`)

## 🔍 Review Process

1. Automated checks run on PR
2. Maintainers review code
3. Feedback addressed
4. Approved and merged

## 🤝 Code of Conduct

- Be respectful and inclusive
- Welcome newcomers
- Accept constructive criticism
- Focus on what's best for the project

## 💬 Communication

- Use GitHub issues for bugs and features
- Be clear and concise
- Provide context and examples
- Be patient and respectful

## 📚 Resources

- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [VS Code Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Shell Style Guide](https://google.github.io/styleguide/shellguide.html)

## 🎉 Recognition

Contributors will be recognized in:
- GitHub contributors list
- CHANGELOG.md for significant contributions

Thank you for contributing! 🚀
