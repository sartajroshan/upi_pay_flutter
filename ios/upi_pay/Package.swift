// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "upi_pay",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "upi-pay", targets: ["upi_pay", "upi_pay_objc"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "upi_pay",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ],
            path: "Sources/upi_pay"
        ),
        .target(
            name: "upi_pay_objc",
            dependencies: [
                "upi_pay",
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ],
            path: "Sources/upi_pay_objc",
            publicHeadersPath: "."
        )
    ]
)
