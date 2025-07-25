# 🏠 Block Estate

## 🔍 Overview

**Block Estate** is a decentralized real estate trading platform enabling users to list, tokenize, and purchase properties using blockchain technology. Built on Ethereum with Solidity smart contracts, it supports both **full and fractional ownership**, making real estate investment more accessible and flexible.

Transactions are powered by **ETH** and secured via **MetaMask**, while development and testing are conducted on a local **Ganache blockchain**.

---

## ✨ Features

### 🔗 Tokenized Real Estate
- Properties are represented by **ERC-based tokens**.
- Tokenization options:
  - **Single token** for full ownership
  - **Multiple tokens** for fractional ownership

### 💰 ETH-Powered Transactions
- All transactions use **Ethereum (ETH)**.
- Smart contracts ensure instant and trustless transfers.

### 👥 Fractional Ownership
- Allows **multiple users** to co-own a property.
- Ownership share is determined by token quantity.

### 🔒 Secure Smart Contracts
- Written in **Solidity**, deployed on Ethereum.
- Eliminates middlemen with decentralized logic.

### 🔄 Real-Time Wallet Integration
- **MetaMask** is required for all operations.
- Transactions are signed and approved securely via wallet.

### 🧪 Local Development with Ganache
- **Ganache** used for simulating Ethereum network locally.
- Safe environment for development and debugging.

### 🖥️ Modern React Frontend
- UI built with **React.js**.
- Blockchain interaction handled via **Web3.js** or **Ethers.js**.

---

## ⚙️ How It Works

### 🧭 System Flow

```mermaid
graph LR
    A[User Opens Web App (React)] --> B[Connect MetaMask Wallet]
    B --> C[View Listed Properties]
    C --> D[Choose to List or Buy Property]

    D -->|List Property| E[Enter Property Details + No. of Tokens]
    E --> F[Smart Contract Mints Token(s)]
    F --> G[Ownership Recorded on Blockchain]

    D -->|Buy Property| H[Select Token(s) to Buy]
    H --> I[Confirm & Pay ETH via MetaMask]
    I --> J[Smart Contract Transfers Tokens]
    J --> K[Ownership Updated on Blockchain]

    G --> L[Transaction History View]
    K --> L

📌 Project Status
🚧 In Development — Currently running on local Ganache.

🧪 Next Step — Deploy to Ethereum Testnet for live testing.

🤝 Contributing
Contributions are welcome!
Please open an issue to discuss changes before submitting a pull request.

📫 Contact
For inquiries or collaboration:

yash.zanwar.10.10@gmail.com
harshwalke16@gmail.com
saif.khan10082006@gmail.com
eklavya.puri11@gmail.com
patilsiddhi885@gmail.com
